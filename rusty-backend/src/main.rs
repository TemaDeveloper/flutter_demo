use axum::{routing::{get, patch, post}, Extension, Router};
use user::update;

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
        .route("/user/update/:id", patch(user::update))
        .layer(Extension(util::connect_to_db().await?));

    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000")
        .await?;
    axum::serve(listener, app).await?;

    Ok(())
}

