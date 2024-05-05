use axum::{routing::{get, post}, Extension, Router};

mod util;
mod user;
mod entity;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    dotenv::dotenv()?;
    tracing_subscriber::fmt::init();

    let app = Router::new()
        .route("/user", post(user::create))
        .route("/user/:id", get(user::get))
        .layer(Extension(util::connect_to_db().await?));

    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000")
        .await?;
    axum::serve(listener, app).await?;

    Ok(())
}

