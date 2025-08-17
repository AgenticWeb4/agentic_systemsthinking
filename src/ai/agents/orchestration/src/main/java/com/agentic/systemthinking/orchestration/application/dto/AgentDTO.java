package com.agentic.systemthinking.orchestration.application.dto;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 智能体数据传输对象
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AgentDTO {
    
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
    private String status;
    
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
    private HealthStatusDTO healthStatus;
}
