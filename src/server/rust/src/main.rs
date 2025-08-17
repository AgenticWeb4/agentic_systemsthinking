use actix_web::{web, App, HttpServer, HttpResponse, Result};
use actix_web::middleware::Logger;
use actix_cors::Cors;
use serde::Serialize;
use std::env;
use log::info;

#[derive(Serialize)]
struct HealthResponse {
    status: String,
    timestamp: String,
    service: String,
}

#[derive(Serialize)]
struct DbHealthResponse {
    status: String,
    timestamp: String,
    service: String,
    database: String,
}

async fn health_check() -> Result<HttpResponse> {
    let response = HealthResponse {
        status: "Rust Backend Service Status: Healthy".to_string(),
        timestamp: chrono::Utc::now().to_rfc3339(),
        service: "rust-backend".to_string(),
    };
    
    info!("Health check requested");
    Ok(HttpResponse::Ok().json(response))
}

async fn db_health_check() -> Result<HttpResponse> {
    let response = DbHealthResponse {
        status: "Database connection: Healthy (simulated)".to_string(),
        timestamp: chrono::Utc::now().to_rfc3339(),
        service: "rust-backend".to_string(),
        database: "postgresql".to_string(),
    };
    info!("Database health check: Healthy (simulated)");
    Ok(HttpResponse::Ok().json(response))
}

async fn check_other_health() -> Result<HttpResponse> {
    let results = vec![
        "Java Backend: Service check simulated".to_string(),
        "Agent System: Service check simulated".to_string(),
    ];
    
    Ok(HttpResponse::Ok().json(results))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv::dotenv().ok();
    env_logger::init();
    
    info!("Starting Rust backend service on port 8001");
    
    HttpServer::new(move || {
        let cors = Cors::default()
            .allow_any_origin()
            .allow_any_method()
            .allow_any_header();
            
        App::new()
            .wrap(cors)
            .wrap(Logger::default())
            .route("/health", web::get().to(health_check))
            .route("/db-health", web::get().to(db_health_check))
            .route("/check-services", web::get().to(check_other_health))
    })
    .bind("0.0.0.0:8001")?
    .run()
    .await
}
