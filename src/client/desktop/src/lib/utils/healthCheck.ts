import type { ServiceStatus, ServiceConfig, ServiceName, HealthCheckResult } from '$lib/types/service';

// 健康检查响应解析器接口
interface HealthResponseParser {
  parseStatus(data: any): 'Healthy' | 'Unhealthy';
  parseDatabaseStatus(data: any): 'Healthy' | 'Unhealthy' | 'N/A';
}

// 服务特定的健康检查解析器
const healthParsers: Record<string, HealthResponseParser> = {
  rust: {
    parseStatus: (data) => data.status === 'Rust Backend Service Status: Healthy' ? 'Healthy' : 'Unhealthy',
    parseDatabaseStatus: (data) => data.status === 'Database connection: Healthy (simulated)' ? 'Healthy' : 'Unhealthy'
  },
  java: {
    parseStatus: (data) => data.status === 'Java Backend Service Status: Healthy' ? 'Healthy' : 'Unhealthy',
    parseDatabaseStatus: (data) => data.status === 'Database connection: Healthy' ? 'Healthy' : 'Unhealthy'
  },
  agent: {
    parseStatus: (data) => data.status === 'healthy' ? 'Healthy' : 'Unhealthy',
    parseDatabaseStatus: () => 'N/A'
  },
  javaAgent: {
    parseStatus: (data) => data.status === 'UP' ? 'Healthy' : 'Unhealthy',
    parseDatabaseStatus: (data) => data.components?.db?.status === 'UP' ? 'Healthy' : 
                                   (data.components?.db ? 'Unhealthy' : 'N/A')
  },
  orchestration: {
    parseStatus: (data) => data.status === 'UP' ? 'Healthy' : 'Unhealthy',
    parseDatabaseStatus: (data) => data.components?.db?.status === 'UP' ? 'Healthy' : 
                                  (data.components?.db ? 'Unhealthy' : 'N/A')
  }
};

export async function checkServiceHealth(config: ServiceConfig): Promise<HealthCheckResult> {
  try {
    // 检查服务健康状态
    const healthResponse = await fetch(config.healthEndpoint, {
      method: 'GET',
      headers: { 'Accept': 'application/json' },
      signal: AbortSignal.timeout(5000) // 5秒超时
    });
    
    if (!healthResponse.ok) {
      throw new Error(`HTTP ${healthResponse.status}: ${healthResponse.statusText}`);
    }
    
    const healthData = await healthResponse.json();
    const parser = healthParsers[config.name];
    
    if (!parser) {
      console.warn(`No parser found for service: ${config.name}`);
      return {
        service: config.name,
        status: { status: 'Unhealthy', db: 'Unhealthy' },
        success: false,
        error: `No parser found for service: ${config.name}`,
        timestamp: new Date()
      };
    }
    
    const startTime = Date.now();
    const status = parser.parseStatus(healthData);
    let db: ServiceStatus['db'] = 'N/A';
    
    // 检查数据库状态
    if (config.dbHealthEndpoint) {
      try {
        const dbResponse = await fetch(config.dbHealthEndpoint, {
          method: 'GET',
          headers: { 'Accept': 'application/json' },
          signal: AbortSignal.timeout(5000) // 5秒超时
        });
        
        if (dbResponse.ok) {
          const dbData = await dbResponse.json();
          db = parser.parseDatabaseStatus(dbData);
        } else {
          db = 'Unhealthy';
        }
      } catch (error) {
        console.warn(`Database health check failed for ${config.name}:`, error);
        db = 'Unhealthy';
      }
    } else {
      // 如果没有数据库健康检查端点，使用服务状态
      db = status === 'Healthy' ? 'Healthy' : 'Unhealthy';
    }
    
    const responseTime = Date.now() - startTime;
    
    return {
      service: config.name,
      status: { 
        status, 
        db, 
        lastChecked: new Date(),
        responseTime 
      },
      success: true,
      timestamp: new Date()
    };
  } catch (error) {
    console.error(`Health check failed for ${config.name}:`, error);
    return {
      service: config.name,
      status: { status: 'Unhealthy', db: 'Unhealthy' },
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error',
      timestamp: new Date()
    };
  }
}

export const serviceConfigs: ServiceConfig[] = [
  {
    name: 'rust',
    title: 'Rust后端服务',
    healthEndpoint: '/api/rust/health',
    dbHealthEndpoint: '/api/rust/db-health'
  },
  {
    name: 'java',
    title: 'Java后端服务',
    healthEndpoint: '/api/java/health',
    dbHealthEndpoint: '/api/java/db-health'
  },
  {
    name: 'agent',
    title: 'Python智能体系统',
    healthEndpoint: '/api/python/health'
  },
  {
    name: 'javaAgent',
    title: 'Java智能体系统',
    healthEndpoint: '/api/java-agent/actuator/health'
  },
  {
    name: 'orchestration',
    title: '编排服务',
    healthEndpoint: '/api/orchestration/actuator/health'
  }
];
