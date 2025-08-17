package com.agentic.systemthinking.agents.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * 智能体配置类
 */
@Configuration
public class AgentConfig {

    /**
     * 配置 RestTemplate
     */
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
