package com.agentic.systemthinking.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class HealthController {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private RestTemplate restTemplate;

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "Java Backend Service Status: Healthy");
        response.put("timestamp", LocalDateTime.now().toString());
        response.put("service", "java-backend");
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/db-health")
    public ResponseEntity<Map<String, Object>> dbHealthCheck() {
        Map<String, Object> response = new HashMap<>();
        
        try (Connection connection = dataSource.getConnection()) {
            response.put("status", "Database connection: Healthy");
            response.put("timestamp", LocalDateTime.now().toString());
            response.put("service", "java-backend");
            response.put("database", "postgresql");
            return ResponseEntity.ok(response);
        } catch (SQLException e) {
            response.put("status", "Database connection: Unhealthy - " + e.getMessage());
            response.put("timestamp", LocalDateTime.now().toString());
            response.put("service", "java-backend");
            response.put("database", "postgresql");
            return ResponseEntity.status(503).body(response);
        }
    }

    @GetMapping("/check-services")
    public ResponseEntity<List<String>> checkOtherServices() {
        List<String> results = new ArrayList<>();
        
        // 检查Rust后端服务
        try {
            String rustResponse = restTemplate.getForObject("http://localhost:8001/health", String.class);
            results.add("Rust Backend: " + rustResponse);
        } catch (Exception e) {
            results.add("Rust Backend: Unhealthy - " + e.getMessage());
        }
        
        // 检查智能体系统
        try {
            String agentResponse = restTemplate.getForObject("http://localhost:8003/health", String.class);
            results.add("Agent System: " + agentResponse);
        } catch (Exception e) {
            results.add("Agent System: Unhealthy - " + e.getMessage());
        }
        
        return ResponseEntity.ok(results);
    }
}
