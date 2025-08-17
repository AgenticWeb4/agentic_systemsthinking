#!/usr/bin/env python3
"""
Python 智能体启动脚本
"""
import uvicorn
import os
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

# 导入FastAPI应用
from interfaces.api import app

if __name__ == "__main__":
    # 获取配置
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", 8003))
    
    # 启动服务
    uvicorn.run(app, host=host, port=port, reload=False)
