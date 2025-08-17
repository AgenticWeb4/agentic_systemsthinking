package com.agentic.systemthinking.orchestration.domain.service;

import com.agentic.systemthinking.orchestration.domain.entity.Agent;
import com.agentic.systemthinking.orchestration.domain.valueobject.HealthStatus;

/**
 * 智能体健康检查领域服务
 */
public interface AgentHealthService {
    
    /**
     * 检查智能体健康状态
     * 
     * @param agent 智能体
     * @return 健康状态
     */
    HealthStatus checkHealth(Agent agent);
    
    /**
     * 批量检查智能体健康状态
     * 
     * @param agents 智能体列表
     */
    void checkHealthBatch(java.util.List<Agent> agents);
    
    /**
     * 更新智能体健康状态
     * 
     * @param agent 智能体
     * @param healthStatus 健康状态
     */
    void updateHealthStatus(Agent agent, HealthStatus healthStatus);
}
