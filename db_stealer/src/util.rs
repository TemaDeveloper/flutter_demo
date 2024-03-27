use crate::sponacular; 
use futures::TryFutureExt;
use std::io;
use tokio::{
    fs::{File, OpenOptions},
    io::{AsyncReadExt, AsyncSeekExt, AsyncWriteExt, SeekFrom},
};


pub async fn read_last_line(file: &mut File) -> io::Result<Option<String>> {
    let mut buf = vec![0u8; 1024];
    let mut offset = 0i64;

    loop {
        file.seek(SeekFrom::End(-offset - buf.len() as i64)).await?;
        if file.read(&mut buf).await? == 0 {
            break Ok(None);
        }

        let idx = buf
            .iter()
            .rev()
            .skip(1)
            .enumerate()
            .find_map(|(idx, &c)| if c == '\n' as u8 { Some(idx) } else { None })
            .map(|idx| buf.len() - idx - 1);

        if let Some(idx) = idx {
            break Ok(Some(String::from_utf8_lossy(&buf[idx..]).to_string()));
        }

        offset += buf.len() as i64;
    }
}

pub async fn get_file() -> io::Result<(File, usize)> {
    let mut file = OpenOptions::new()
        .append(true)
        .read(true)
        .open(&format!("./recipes.csv"))
        .or_else(|e| async {
            match e.kind() {
                io::ErrorKind::NotFound => {
                    // If the file does not exist, create it.
                    OpenOptions::new()
                        .create_new(true)
                        .write(true)
                        .open(&format!("./recipes.csv"))
                        .await
                }
                _ => Err(e),
            }
        })
        .await?;

    if file.metadata().await?.len() > 0 {
        let last_line = read_last_line(&mut file).await?;

        let offset = if let Some(last_line) = last_line {
            let comma_idx = last_line
                .chars()
                .enumerate()
                .find_map(|(idx, c)| if c == ',' { Some(idx) } else { None })
                .unwrap();
            let last_idx = last_line[0..comma_idx].parse::<usize>().unwrap();
            last_idx + 1
        } else {
            file.write_all(sponacular::recipe_csv_header().as_bytes()).await?;
            0
        };

        Ok((file, offset))
    } else {
        Ok((file, 0))
    }
}
