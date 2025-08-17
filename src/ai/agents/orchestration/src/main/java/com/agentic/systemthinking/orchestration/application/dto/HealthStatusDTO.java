package com.agentic.systemthinking.orchestration.application.dto;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

/**
 * 健康状态数据传输对象
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HealthStatusDTO {
    
    /**
     * 是否健康
     */
    private boolean healthy;
    
    /**
     * 状态消息
     */
    private String message;
    
    /**
     * 响应时间（毫秒）
     */
    private Long responseTime;
    
    /**
     * 检查时间
     */
    private LocalDateTime checkTime;
    
    /**
     * 错误信息
     */
    private String error;
}
