package com.agentic.systemthinking.orchestration.application.service;

import com.agentic.systemthinking.orchestration.application.dto.AgentDTO;
import com.agentic.systemthinking.orchestration.application.dto.HealthStatusDTO;

import java.util.List;
import java.util.Map;

/**
 * 编排服务应用服务
 */
public interface OrchestrationService {
    
    /**
     * 获取所有智能体
     * 
     * @return 智能体列表
     */
    List<AgentDTO> getAllAgents();
    
    /**
     * 根据类型获取智能体
     * 
     * @param type 智能体类型
     * @return 智能体列表
     */
    List<AgentDTO> getAgentsByType(String type);
    
    /**
     * 根据能力获取智能体
     * 
     * @param capability 能力
     * @return 智能体列表
     */
    List<AgentDTO> getAgentsByCapability(String capability);
    
    /**
     * 获取智能体健康状态
     * 
     * @param agentId 智能体ID
     * @return 健康状态
     */
    HealthStatusDTO getAgentHealthStatus(String agentId);
    
    /**
     * 检查所有智能体健康状态
     */
    void checkAllAgentsHealth();
    
    /**
     * 获取统计信息
     * 
     * @return 统计信息
     */
    Map<String, Object> getStatistics();
}
