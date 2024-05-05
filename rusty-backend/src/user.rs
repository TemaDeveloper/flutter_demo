use anyhow::Context;
use axum::{http::StatusCode, response::IntoResponse, Extension, Json};
use sea_orm::{ActiveModelTrait, DatabaseConnection, Set};
use serde::{Deserialize, Serialize};

use crate::entity::users;

#[derive(Debug, Serialize, Deserialize)]
pub struct CreatePayload {
    name: String,
    last_name: String,
    email: String,
    password: Vec<u8>
}

/* test:
    * curl -X POST http://127.0.0.1:3000/user -H "Content-Type: application/json" -d '{"name": "Eduard", "last_name": "Kechedzhiev", "password": [1,2,3,2,12,3,122], "email": "ed@mail.ru"}'

 */
pub async fn create(
    Extension(db_conn): Extension<DatabaseConnection>,
    Json(payload): Json<CreatePayload>
) -> impl IntoResponse {
    let user = users::ActiveModel {
        name: Set(payload.name),
        last_name: Set(payload.last_name), 
        email: Set(payload.email), 
        password: Set(payload.password), 
        ..Default::default()
    }
        .insert(&db_conn)
        .await
        .context("Inserting into the Users")
        .unwrap();

    tracing::info!("Creating user: {:?}", &user);
    
    (StatusCode::OK, Json(user))
}
