use dotenv::dotenv;
use futures::{future, TryFutureExt};
use lazy_static::lazy_static;
use reqwest::StatusCode;
use serde::{Deserialize, Serialize};
use std::{env, fmt, io::{self, SeekFrom}, time::Duration};
use tokio::{fs::{File, OpenOptions}, io::{AsyncReadExt, AsyncSeekExt, AsyncWriteExt}, signal, sync::{self, mpsc}, time};

const REQ_PER_SEC: usize = 1;
const RECIPES_PER_REQ: usize = 80;

#[derive(thiserror::Error, Debug)]
enum WorkerError {
    #[error("Error requesting uri: {0}")]
    RequestError(String),

    #[error("Error requesting, body=\n{0}")]
    ResponseError(String),

    #[error("Error parsing request body {0}")]
    ParsingBody(String),

    // #[error("Could not send:\n{0}")]
    // SendError(SponacularResponse)
}

#[derive(Serialize, Deserialize, Debug, PartialEq, PartialOrd, Clone)]
enum ImageType {
    #[serde(rename = "jpeg")]
    Jpeg,
    #[serde(rename = "jpg")]
    Jpg,
    #[serde(rename = "png")]
    Png,
    #[serde(rename = "gif")]
    Gif,
    #[serde(rename = "svg")]
    Svg,
    #[serde(rename = "bmp")]
    Bmp,
    #[serde(rename = "tiff")]
    Tiff,
    #[serde(rename = "webp")]
    Webp,
}

impl fmt::Display for ImageType {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let s = match self {
            ImageType::Jpeg => "jpeg",
            ImageType::Jpg => "jpg",
            ImageType::Png => "png",
            ImageType::Gif => "gif",
            ImageType::Svg => "svg",
            ImageType::Bmp => "bmp",
            ImageType::Tiff => "tiff",
            ImageType::Webp => "webp",
        };
        write!(f, "{}", s)
    }
}

#[derive(Serialize, Deserialize, Clone, Debug)]
struct Recipe {
    id: usize,
    title: String,
    #[serde(rename = "image")]
    image_url: String,
    #[serde(rename = "imageType")]
    image_type: ImageType,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
struct SponacularResponse {
    #[serde(skip)]
    idx: usize,
    results: Vec<Recipe>
}

impl fmt::Display for SponacularResponse {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let str_rep = self.results.iter().enumerate().map(|(i,recp)| {
            format!("{idx},{id},{title},{image_url},{image_type}\n",
                idx = i + self.idx,
                id = recp.id,
                title = recp.title,
                image_url = recp.image_url,
                image_type = recp.image_type.to_string()
            )
        }).collect::<Vec<_>>().join("");
        write!(f, "{}", str_rep)?;
        Ok(())
    }
}

lazy_static! {
    static ref CLIENT: reqwest::Client = reqwest::Client::new();
    static ref RUNNING: sync::Mutex<bool> = sync::Mutex::new(true);
}

async fn read_last_line(file: &mut File) -> io::Result<Option<String>> {
    let mut buf = vec![0u8; 1024];
    let mut offset = 0i64;

    loop {
        file.seek(SeekFrom::End(-offset - buf.len() as i64)).await?;
        if file.read(&mut buf).await? == 0 {
            break Ok(None);
        }

        let idx = buf.iter()
            .rev()
            .skip(1)
            .enumerate()
            .find_map(|(idx, &c)| if c == '\n' as u8 {
               Some(idx) 
            } else {
                None
            })
            .map(|idx| buf.len() - idx - 1);

        if let Some(idx) = idx {
            break Ok(Some(String::from_utf8_lossy(&buf[idx..]).to_string()));
        }

        offset += buf.len() as i64;
    }
}

async fn writer_worker(mut r: mpsc::UnboundedReceiver<SponacularResponse>, mut f: File) -> io::Result<()> {
    while let Some(resp) = r.recv().await {
        let mut lock = RUNNING.lock().await; 
        if resp.results.len() == 0 || !*lock{
            log::info!("No more data, quitting...");
            *lock = false;
            return Ok(())
        };

        f.write_all(resp.to_string().as_bytes())
            .await?;
        f.flush()
            .await?;
    }

    Ok(())
}

async fn worker(req_uri: String, s: mpsc::UnboundedSender<SponacularResponse>, idx: usize) -> Result<(), WorkerError> {
    let resp = CLIENT.get(&req_uri)
        .send().await
        .map_err(|e| WorkerError::RequestError(e.to_string()))?;

    let resp_code = resp.status();
    if resp_code != StatusCode::from_u16(200).unwrap() {
        return match resp.text().await {
            Ok(t)  => Err(WorkerError::ResponseError(t)),
            Err(e) => Err(WorkerError::ParsingBody(e.to_string())),
        }
    }

    let resp = resp.text()
        .map_err(|e| WorkerError::ParsingBody(e.to_string()))
        .await?;

    let mut resp: SponacularResponse = serde_json::from_str(&resp)
        .map_err(|e| WorkerError::ParsingBody(e.to_string()))?;

    resp.idx = idx;

    let _ = s.send(resp);
    
    Ok(())
}

async fn get_file(cuisine: &str) -> io::Result<(File, usize)> {
    let mut file = OpenOptions::new()
        .append(true)
        .read(true)
        .open(&format!("./{cuisine}_recipes.csv"))
        .or_else(|e| async {
            match e.kind() {
                io::ErrorKind::NotFound => {
                    // If the file does not exist, create it.
                    OpenOptions::new()
                        .create_new(true)
                        .write(true)
                        .open(&format!("./{cuisine}_recipes.csv")).await
                },
                _ => {
                    Err(e)
                },
            }
        }).await?;

    if file.metadata().await?.len() > 0 {
        let last_line = read_last_line(&mut file).await?;

        let offset = if let Some(last_line) = last_line {
            let comma_idx = last_line.chars().enumerate().find_map(|(idx, c)| if c == ',' { Some(idx) } else { None }).unwrap();
            let last_idx = last_line[0..comma_idx].parse::<usize>().unwrap();
            last_idx + 1
        } else {
            0
        };

        Ok((file,offset))
    } else {
        Ok((file, 0))
    }
}

#[tokio::main]
async fn main() -> anyhow::Result<()>{
    env_logger::Builder::from_env(env_logger::Env::default().default_filter_or("info")).init();
    dotenv().expect(".evn file not found");
    tokio::spawn(async {
        signal::ctrl_c().await.expect("Failed to listen for event");
        *RUNNING.lock().await = false;
        log::info!("Ctrl+C received, exiting...");
    });

    let cuisine = env::args().nth(1).expect("Supply cuisine name!");
    log::info!("Quering {cuisine} cuisine");

    let api_key = env::var("API_KEY")?;
    let (sender, recivier) = mpsc::unbounded_channel::<SponacularResponse>();
    let (file, mut offset) = get_file(&cuisine).await?;
    if offset != 0 {
        log::info!("Found file, starting at idx: {}", offset/RECIPES_PER_REQ);
    }
    let writer = tokio::spawn(writer_worker(recivier, file));

    while *RUNNING.lock().await {
        let timer = tokio::spawn(time::sleep(Duration::from_secs(2)));

        let handles: Vec<_> = (0..REQ_PER_SEC).map(|_| {
            let req_url = format!("https://api.spoonacular.com/recipes/complexSearch?number={}{qoffset}&apiKey={}&cuisine={}", 
                RECIPES_PER_REQ, 
                api_key,
                cuisine,
                qoffset = if offset == 0 {"".to_string()} else { format!("&offset={offset}") }
            );
            log::info!("Curent idx: {}", offset / RECIPES_PER_REQ);
            let worker = tokio::spawn(worker(req_url, sender.clone(), offset));
            offset += RECIPES_PER_REQ;
            worker
        }).collect();

        for h in future::try_join_all(handles).await? {
            h?;
        }

        timer.await?;
    }

    drop(sender);
    writer.await??;
    log::info!("Done!");
    Ok(())
}
