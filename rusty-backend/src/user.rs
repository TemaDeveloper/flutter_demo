use anyhow::Context;
use axum::{extract::Path, http::StatusCode, response::IntoResponse, Extension, Json};
use sea_orm::{ActiveModelTrait, DatabaseConnection, DbErr, EntityTrait, Set};
use serde::{Deserialize, Serialize};

use crate::entity::users::{self, ActiveModel};

#[derive(Debug, Serialize, Deserialize)]
pub struct CreatePayload {
    name: String,
    last_name: String,
    email: String,
    password: Vec<u8>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct UpdatePayload {
    name: Option<String>,
    last_name: Option<String>,
    email: Option<String>,
    password: Option<String>,
}

/* test:
   * curl -X POST http://127.0.0.1:3000/user -H "Content-Type: application/json" -d '{"name": "Eduard", "last_name": "Kechedzhiev", "password": [1,2,3,2,12,3,122], "email": "ed@mail.ru"}'

*/
pub async fn create(
    Extension(db_conn): Extension<DatabaseConnection>,
    Json(payload): Json<CreatePayload>,
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

pub async fn get(
    Extension(db_conn): Extension<DatabaseConnection>,
    Path(user_id): Path<i32>,
) -> (StatusCode, Json<Result<users::Model, String>>){
    let user = users::Entity::find_by_id(user_id)
        .one(&db_conn)
        .await
        .context("Fetching user from data base")
        .unwrap();

    match user {
        Some(user) => (StatusCode::OK, Json(Ok(user))),
        None => (StatusCode::NOT_FOUND, Json(Err("Could not find user".to_string()))),
    }
}

pub async fn update(
    Extension(db_conn):Extension<DatabaseConnection>,
    Path(user_id): Path<i32>,
    Json(payload): Json<UpdatePayload>,
) -> Result<users::Model, DbErr> {

    let mut user: ActiveModel = users::Entity::find_by_id(user_id)
        .one(&db_conn)
        .await?
        .ok_or(DbErr::Custom("Cannot find user updates".to_owned()))?
        .into();

    if let Some(name) = payload.name {
        user.name = Set(name);
    }
    if let Some(last_name) = payload.last_name {
        user.last_name = Set(last_name);
    }
    if let Some(email) = payload.email {
        user.email = Set(email);
    }
    
    let updated_user = user.update(&db_conn).await?;
    Ok(updated_user)

    
}
