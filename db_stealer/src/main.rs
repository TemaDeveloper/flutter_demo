use dotenv::dotenv;
use futures::{future, TryFutureExt};
use lazy_static::lazy_static;
use reqwest::StatusCode;
use std::{env, time::Duration};
use tokio::{fs::File, io::{self, AsyncWriteExt}, signal, sync::{self, mpsc}, time};

mod sponacular;
mod util;

pub const REQ_PER_SEC: usize = 1;
pub const RECIPES_PER_REQ: usize = 80;

#[derive(thiserror::Error, Debug)]
enum WorkerError {
    #[error("Error requesting uri: {0}")]
    RequestError(String),

    #[error("Error requesting, body=\n{0}")]
    ResponseError(String),

    #[error("Error parsing request body {0}")]
    ParsingBody(String),
}

lazy_static! {
    pub static ref CLIENT: reqwest::Client = reqwest::Client::new();
    pub static ref RUNNING: sync::Mutex<bool> = sync::Mutex::new(true);
}

async fn writer_worker(mut r: mpsc::UnboundedReceiver<sponacular::Response>, mut f: File) -> io::Result<()> {
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

async fn worker(req_uri: String, s: mpsc::UnboundedSender<sponacular::Response>, idx: usize) -> Result<(), WorkerError> {
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

    let mut resp: sponacular::Response = serde_json::from_str(&resp)
        .map_err(|e| WorkerError::ParsingBody(e.to_string()))?;

    resp.idx = idx;

    s.send(resp).unwrap();
    
    Ok(())
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

    let api_key = env::var("API_KEY")?;
    let (sender, recivier) = mpsc::unbounded_channel::<sponacular::Response>();
    let (file, mut offset) = util::get_file().await?;
    if offset != 0 {
        log::info!("Found file, starting at idx: {}", offset/RECIPES_PER_REQ);
    }
    let writer = tokio::spawn(writer_worker(recivier, file));

    while *RUNNING.lock().await {
        let timer = tokio::spawn(time::sleep(Duration::from_secs(2)));

        let handles: Vec<_> = (0..REQ_PER_SEC).map(|_| {
            let req_url = format!("https://api.spoonacular.com/recipes/complexSearch?number={}{qoffset}&apiKey={}&addRecipeInformation=true", 
                RECIPES_PER_REQ, 
                api_key,
                qoffset = if offset == 0 {"".to_string()} else { format!("&offset={offset}") }
            );

            dbg!(&req_url);
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
