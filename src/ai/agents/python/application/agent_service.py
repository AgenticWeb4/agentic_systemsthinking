"""
Python 智能体应用层
"""
from typing import Dict, Any, List, Optional
from domain.agent import PythonAgent

class AgentService:
    """智能体服务"""
    
    def __init__(self):
        self._agents: Dict[str, PythonAgent] = {}
        self._task_history: List[Dict[str, Any]] = []
    
    async def create_agent(self, name: str, capabilities: list, endpoint: str) -> str:
        """创建智能体"""
        agent = PythonAgent(name, capabilities, endpoint)
        self._agents[agent._info.id] = agent
        return agent._info.id
    
    async def get_agent(self, agent_id: str) -> Optional[PythonAgent]:
        """获取智能体"""
        return self._agents.get(agent_id)
    
    async def list_agents(self) -> List[PythonAgent]:
        """列出所有智能体"""
        return list(self._agents.values())
    
    async def execute_task(self, agent_id: str, task: Dict[str, Any]) -> Dict[str, Any]:
        """执行任务"""
        agent = await self.get_agent(agent_id)
        if not agent:
            return {"error": "Agent not found"}
        
        # 记录任务历史
        self._task_history.append(task)
        
        # 执行任务
        result = await agent.execute_task(task)
        return result
    
    async def send_message(self, agent_id: str, message: Dict[str, Any]) -> bool:
        """发送消息给智能体"""
        agent = await self.get_agent(agent_id)
        if not agent:
            return False
        
        return await agent.receive_message(message)
    
    async def get_agent_status(self, agent_id: str) -> Optional[str]:
        """获取智能体状态"""
        agent = await self.get_agent(agent_id)
        if not agent:
            return None
        
        return await agent.get_status()
    
    async def get_task_history(self) -> List[Dict[str, Any]]:
        """获取任务历史"""
        return self._task_history
    
    async def health_check_all(self) -> Dict[str, Any]:
        """检查所有智能体健康状态"""
        results = {}
        for agent_id, agent in self._agents.items():
            try:
                health = await agent.health_check()
                results[agent_id] = health
            except Exception as e:
                results[agent_id] = {"error": str(e)}
        
        return results
