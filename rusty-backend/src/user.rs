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

#[derive(Clone, Debug)]
pub struct FetchPayload{
    user_id: i32,
}

pub struct UpdatePayload{
    name: Option<String>, 
    last_name: Option<String>, 
    email: Option<String>,
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


pub async fn get(
    Extension(db_conn):Extension<DatabaseConnection>, 
    Path(user_id): Path<i32>
) -> impl IntoResponse{
    let user = users::entity::users::find_by_id(user_id)
        .one(&db_conn)
        .await
        .expect("Failed to fetch user");

    match user{
        Some(user) => (StatusCode::OK, Json(user)),
        None => (StatusCode::NOT_FOUND, Json("User not found")),
    }
}

pub async fn update(
    Extension(db_conn):Extension<DatabaseConnection>, 
    Path(user_id): Path<i32>,
    Json(payload): Json<UpdatePayload>
) -> impl IntoResponse{
    let user = match users::entity::users::find_by_id(user_id).one(&db_conn).await{
        Ok(Some(user))=>user,
        Ok(None) => return (StatusCode::NOT_FOUND, Json("User not found")), 
        Err(_) => return (StatusCode::INTERNAL_SERVER_ERROR, Json("Database Error")), 

    };

    if let Some(name) = payload.name {
        user.name = Set(name);
    }
    if let Some(last_name) = payload.last_name {
        user.last_name = Set(last_name);
    }
    if let Some(email) = payload.email {
        user.email = Set(email);
    }
    if let Some(password) = payload.password {
        user.password = Set(password);
    }

    match user.update(&db_conn).await{
        Ok(update_user) => (StatusCode::OK, Json(update_user)),
        Err(_) => (StatusCode::INTERNAL_SERVER_ERROR, Json("Failed to update User")),
    }


}
