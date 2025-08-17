package com.agentic.systemthinking.agents;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * Java 智能体主应用类
 * 系统思维智能体项目
 */
@SpringBootApplication
@EnableDiscoveryClient
public class JavaAgentApplication {

    public static void main(String[] args) {
        SpringApplication.run(JavaAgentApplication.class, args);
    }
}
