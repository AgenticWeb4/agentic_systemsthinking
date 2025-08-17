#!/usr/bin/env python3
"""
Python 智能体系统主程序
系统思维智能体项目
"""

import uvicorn
from .interfaces.api import app

if __name__ == "__main__":
    uvicorn.run(
        "src.ai.agents.python.interfaces.api:app",
        host="0.0.0.0",
        port=8003,
        reload=True,
        log_level="info"
    )
