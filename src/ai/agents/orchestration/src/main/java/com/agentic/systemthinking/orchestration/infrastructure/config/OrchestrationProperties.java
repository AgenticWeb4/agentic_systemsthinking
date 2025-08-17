package com.agentic.systemthinking.orchestration.infrastructure.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * 编排服务配置属性
 */
@Data
@Component
@ConfigurationProperties(prefix = "orchestration")
public class OrchestrationProperties {
    
    /**
     * 健康检查间隔（毫秒）
     */
    private long healthCheckInterval = 30000;
    
    /**
     * 超时时间（毫秒）
     */
    private long timeout = 5000;
    
    /**
     * 重试次数
     */
    private int retryCount = 3;
    
    /**
     * 熔断器配置
     */
    private CircuitBreaker circuitBreaker = new CircuitBreaker();
    
    /**
     * 智能体配置
     */
    private Map<String, AgentConfig> agents;
    
    /**
     * 熔断器配置
     */
    @Data
    public static class CircuitBreaker {
        private boolean enabled = true;
        private int failureThreshold = 5;
        private long recoveryTimeout = 60000;
    }
    
    /**
     * 智能体配置
     */
    @Data
    public static class AgentConfig {
        private String name;
        private String type;
        private String endpoint;
        private String healthCheck;
        private String[] capabilities;
        private Map<String, Object> metadata;
    }
}
