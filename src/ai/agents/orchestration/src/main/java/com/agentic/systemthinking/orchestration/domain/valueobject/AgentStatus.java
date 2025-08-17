package com.agentic.systemthinking.orchestration.domain.valueobject;

/**
 * 智能体状态值对象
 */
public enum AgentStatus {
    
    /**
     * 在线
     */
    ONLINE("online"),
    
    /**
     * 离线
     */
    OFFLINE("offline"),
    
    /**
     * 忙碌
     */
    BUSY("busy"),
    
    /**
     * 错误
     */
    ERROR("error"),
    
    /**
     * 未知
     */
    UNKNOWN("unknown");
    
    private final String value;
    
    AgentStatus(String value) {
        this.value = value;
    }
    
    public String getValue() {
        return value;
    }
    
    public static AgentStatus fromValue(String value) {
        for (AgentStatus status : values()) {
            if (status.value.equals(value)) {
                return status;
            }
        }
        return UNKNOWN;
    }
}
