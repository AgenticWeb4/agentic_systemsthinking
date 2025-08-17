"""
Python 智能体 FastAPI 接口层
"""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict, Any
import asyncio
from datetime import datetime

from application.agent_service import AgentService
from domain.agent import AgentTask, AgentCapability, AgentMessage

app = FastAPI(
    title="Python 智能体系统",
    description="系统思维智能体项目 - Python 智能体服务",
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

# 创建智能体服务实例
agent_service = AgentService()

# 请求模型
class CreateAgentRequest(BaseModel):
    name: str
    capabilities: List[str]
    endpoint: str

class ExecuteTaskRequest(BaseModel):
    agent_id: str
    task_name: str
    task_description: str
    required_capabilities: List[str]
    priority: int = 1

class SendMessageRequest(BaseModel):
    agent_id: str
    receiver_id: str
    message_type: str
    content: Dict[str, Any]

@app.on_event("startup")
async def startup_event():
    """应用启动事件"""
    # 创建默认智能体
    default_capabilities = [
        "SYSTEM_ANALYSIS",
        "PROBLEM_SOLVING"
    ]
    await agent_service.create_agent(
        "SystemAnalysisAgent",
        default_capabilities,
        "http://localhost:8003"
    )

@app.get("/health")
async def health_check():
    """健康检查"""
    return {
        "status": "healthy",
        "service": "python-agent-system",
        "timestamp": datetime.now().isoformat(),
        "port": 8003
    }

@app.post("/agents")
async def create_agent(request: CreateAgentRequest):
    """创建智能体"""
    try:
        agent_id = await agent_service.create_agent(
            request.name,
            request.capabilities,
            request.endpoint
        )
        
        return {
            "status": "success",
            "agent_id": agent_id,
            "message": f"Agent '{request.name}' created successfully"
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/agents")
async def list_agents():
    """列出所有智能体"""
    agents = await agent_service.list_agents()
    return {
        "status": "success",
        "agents": [agent._info.__dict__ for agent in agents]
    }

@app.get("/agents/{agent_id}")
async def get_agent(agent_id: str):
    """获取智能体信息"""
    agent = await agent_service.get_agent(agent_id)
    if not agent:
        raise HTTPException(status_code=404, detail="Agent not found")
    
    return {
        "status": "success",
        "agent": agent._info.dict()
    }

@app.post("/tasks/execute")
async def execute_task(request: ExecuteTaskRequest):
    """执行任务"""
    try:
        # 创建任务
        task = AgentTask(
            name=request.task_name,
            description=request.task_description,
            required_capabilities=[AgentCapability(cap) for cap in request.required_capabilities],
            priority=request.priority
        )
        
        # 执行任务
        result = await agent_service.execute_task(request.agent_id, task)
        
        return {
            "status": "success",
            "result": result
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/messages/send")
async def send_message(request: SendMessageRequest):
    """发送消息"""
    try:
        # 创建消息
        message = AgentMessage(
            sender_id="system",
            receiver_id=request.receiver_id,
            message_type=request.message_type,
            content=request.content
        )
        
        # 发送消息
        success = await agent_service.send_message(request.agent_id, message)
        
        if success:
            return {
                "status": "success",
                "message": "Message sent successfully"
            }
        else:
            raise HTTPException(status_code=400, detail="Failed to send message")
            
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/agents/{agent_id}/status")
async def get_agent_status(agent_id: str):
    """获取智能体状态"""
    status = await agent_service.get_agent_status(agent_id)
    if status is None:
        raise HTTPException(status_code=404, detail="Agent not found")
    
    return {
        "status": "success",
        "agent_status": status.value
    }

@app.get("/health/all")
async def health_check_all():
    """检查所有智能体健康状态"""
    health_status = await agent_service.health_check_all()
    return {
        "status": "success",
        "health_status": health_status
    }

@app.get("/tasks/history")
async def get_task_history():
    """获取任务历史"""
    history = await agent_service.get_task_history()
    return {
        "status": "success",
        "task_history": [task.dict() for task in history]
    }
