use actix_web::{web, App, HttpServer, HttpResponse, Result};
use actix_web::middleware::Logger;
use serde::{Deserialize, Serialize};
use sqlx::PgPool;
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

async fn db_health_check(pool: web::Data<PgPool>) -> Result<HttpResponse> {
    match sqlx::query("SELECT 1").execute(pool.get_ref()).await {
        Ok(_) => {
            let response = DbHealthResponse {
                status: "Database connection: Healthy".to_string(),
                timestamp: chrono::Utc::now().to_rfc3339(),
                service: "rust-backend".to_string(),
                database: "postgresql".to_string(),
            };
            info!("Database health check: Healthy");
            Ok(HttpResponse::Ok().json(response))
        }
        Err(e) => {
            log::error!("Database health check failed: {}", e);
            let response = DbHealthResponse {
                status: format!("Database connection: Unhealthy - {}", e),
                timestamp: chrono::Utc::now().to_rfc3339(),
                service: "rust-backend".to_string(),
                database: "postgresql".to_string(),
            };
            Ok(HttpResponse::ServiceUnavailable().json(response))
        }
    }
}

async fn check_other_services() -> Result<HttpResponse> {
    let mut results = Vec::new();
    
    // 检查Java后端服务
    let java_client = reqwest::Client::new();
    match java_client.get("http://localhost:8002/health").send().await {
        Ok(resp) => {
            if let Ok(text) = resp.text().await {
                results.push(format!("Java Backend: {}", text));
            }
        }
        Err(e) => {
            results.push(format!("Java Backend: Unhealthy - {}", e));
        }
    }
    
    // 检查智能体系统
    let agent_client = reqwest::Client::new();
    match agent_client.get("http://localhost:8003/health").send().await {
        Ok(resp) => {
            if let Ok(text) = resp.text().await {
                results.push(format!("Agent System: {}", text));
            }
        }
        Err(e) => {
            results.push(format!("Agent System: Unhealthy - {}", e));
        }
    }
    
    Ok(HttpResponse::Ok().json(results))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv::dotenv().ok();
    env_logger::init();
    
    let database_url = env::var("DATABASE_URL")
        .unwrap_or_else(|_| "postgres://postgres:password@localhost:5432/mydb".to_string());
    
    let pool = PgPool::connect(&database_url).await.expect("Failed to create pool");
    
    info!("Starting Rust backend service on port 8001");
    
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .wrap(Logger::default())
            .route("/health", web::get().to(health_check))
            .route("/db-health", web::get().to(db_health_check))
            .route("/check-services", web::get().to(check_other_services))
    })
    .bind("0.0.0.0:8001")?
    .run()
    .await
}
