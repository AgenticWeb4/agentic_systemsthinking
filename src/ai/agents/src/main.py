#!/usr/bin/env python3
"""
智能体系统主程序
系统思维智能体项目
"""

import asyncio
import os
from datetime import datetime
from typing import Dict, Any

import httpx
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from loguru import logger
from pydantic import BaseModel
from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker

# 配置日志
logger.add("logs/agent-system.log", rotation="1 day", retention="7 days")

app = FastAPI(
    title="智能体系统",
    description="系统思维智能体项目 - 智能体系统服务",
    version="1.0.0"
)

# 配置CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 数据模型
class HealthResponse(BaseModel):
    status: str
    timestamp: str
    service: str

class DbHealthResponse(BaseModel):
    status: str
    timestamp: str
    service: str
    database: str

# 数据库配置
DATABASE_URL = os.getenv(
    "DATABASE_URL", 
    "postgresql+asyncpg://postgres:password@localhost:5432/mydb"
)

# 创建异步数据库引擎
engine = create_async_engine(DATABASE_URL, echo=True)
AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

@app.get("/health", response_model=HealthResponse)
async def health_check():
    """健康检查端点"""
    logger.info("Health check requested")
    return HealthResponse(
        status="Agent System Service Status: Healthy",
        timestamp=datetime.now().isoformat(),
        service="agent-system"
    )

@app.get("/db-health", response_model=DbHealthResponse)
async def db_health_check():
    """数据库健康检查端点"""
    try:
        async with AsyncSessionLocal() as session:
            result = await session.execute(text("SELECT 1"))
            await result.fetchone()
            
        logger.info("Database health check: Healthy")
        return DbHealthResponse(
            status="Database connection: Healthy",
            timestamp=datetime.now().isoformat(),
            service="agent-system",
            database="postgresql"
        )
    except Exception as e:
        logger.error(f"Database health check failed: {e}")
        raise HTTPException(
            status_code=503,
            detail=f"Database connection: Unhealthy - {str(e)}"
        )

@app.get("/check-services")
async def check_other_services():
    """检查其他服务状态"""
    results = []
    
    # 检查Rust后端服务
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get("http://localhost:8001/health", timeout=5.0)
            results.append(f"Rust Backend: {response.text}")
    except Exception as e:
        results.append(f"Rust Backend: Unhealthy - {str(e)}")
    
    # 检查Java后端服务
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get("http://localhost:8002/health", timeout=5.0)
            results.append(f"Java Backend: {response.text}")
    except Exception as e:
        results.append(f"Java Backend: Unhealthy - {str(e)}")
    
    return results

@app.on_event("startup")
async def startup_event():
    """应用启动事件"""
    logger.info("Starting Agent System service on port 8003")
    
    # 创建日志目录
    os.makedirs("logs", exist_ok=True)

@app.on_event("shutdown")
async def shutdown_event():
    """应用关闭事件"""
    logger.info("Shutting down Agent System service")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8003,
        reload=True,
        log_level="info"
    )
