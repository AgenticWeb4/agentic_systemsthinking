package com.agentic.systemthinking.orchestration.domain.entity;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import com.agentic.systemthinking.orchestration.domain.valueobject.AgentStatus;
import com.agentic.systemthinking.orchestration.domain.valueobject.HealthStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 智能体实体
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Agent {
    
    /**
     * 智能体ID
     */
    private String id;
    
    /**
     * 智能体名称
     */
    private String name;
    
    /**
     * 智能体类型
     */
    private String type;
    
    /**
     * 智能体状态
     */
    private AgentStatus status;
    
    /**
     * 智能体能力列表
     */
    private List<String> capabilities;
    
    /**
     * 智能体端点
     */
    private String endpoint;
    
    /**
     * 健康检查端点
     */
    private String healthCheck;
    
    /**
     * 元数据
     */
    private Map<String, Object> metadata;
    
    /**
     * 创建时间
     */
    private LocalDateTime createdAt;
    
    /**
     * 最后心跳时间
     */
    private LocalDateTime lastHeartbeat;
    
    /**
     * 最后健康检查时间
     */
    private LocalDateTime lastHealthCheck;
    
    /**
     * 健康状态
     */
    private HealthStatus healthStatus;
    
    /**
     * 检查智能体是否健康
     */
    public boolean isHealthy() {
        return healthStatus != null && healthStatus.isHealthy();
    }
    
    /**
     * 检查智能体是否在线
     */
    public boolean isOnline() {
        return status == AgentStatus.ONLINE;
    }
    
    /**
     * 检查智能体是否具有指定能力
     */
    public boolean hasCapability(String capability) {
        return capabilities != null && capabilities.contains(capability);
    }
}
