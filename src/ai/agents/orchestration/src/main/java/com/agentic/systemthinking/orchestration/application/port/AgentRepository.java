package com.agentic.systemthinking.orchestration.application.port;

import com.agentic.systemthinking.orchestration.domain.entity.Agent;

import java.util.List;
import java.util.Optional;

/**
 * 智能体仓库端口接口
 */
public interface AgentRepository {
    
    /**
     * 保存智能体
     * 
     * @param agent 智能体
     * @return 保存后的智能体
     */
    Agent save(Agent agent);
    
    /**
     * 根据ID查找智能体
     * 
     * @param id 智能体ID
     * @return 智能体
     */
    Optional<Agent> findById(String id);
    
    /**
     * 查找所有智能体
     * 
     * @return 智能体列表
     */
    List<Agent> findAll();
    
    /**
     * 根据类型查找智能体
     * 
     * @param type 智能体类型
     * @return 智能体列表
     */
    List<Agent> findByType(String type);
    
    /**
     * 根据能力查找智能体
     * 
     * @param capability 能力
     * @return 智能体列表
     */
    List<Agent> findByCapability(String capability);
    
    /**
     * 删除智能体
     * 
     * @param id 智能体ID
     */
    void deleteById(String id);
}
