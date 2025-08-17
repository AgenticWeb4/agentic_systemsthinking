import type { ServiceStatus, ServiceConfig } from '$lib/types/service';

export async function checkServiceHealth(config: ServiceConfig): Promise<ServiceStatus> {
  try {
    // 检查服务健康状态
    const healthResponse = await fetch(config.healthEndpoint);
    const healthData = await healthResponse.json();
    
    let status: ServiceStatus['status'] = 'Unhealthy';
    let db: ServiceStatus['db'] = 'Unhealthy';
    
    // 根据不同的服务类型解析响应
    if (config.name === 'rust') {
      // Rust后端服务状态解析
      status = healthData.status === 'Rust Backend Service Status: Healthy' ? 'Healthy' : 'Unhealthy';
    } else if (config.name === 'java') {
      // Java后端服务状态解析
      status = healthData.status === 'Java Backend Service Status: Healthy' ? 'Healthy' : 'Unhealthy';
    } else if (config.name === 'agent') {
      status = healthData.status === 'healthy' ? 'Healthy' : 'Unhealthy';
    } else if (config.name === 'javaAgent' || config.name === 'orchestration') {
      status = healthData.status === 'UP' ? 'Healthy' : 'Unhealthy';
    } else {
      status = 'Healthy';
    }
    
    // 检查数据库状态
    if (config.dbHealthEndpoint) {
      try {
        const dbResponse = await fetch(config.dbHealthEndpoint);
        const dbData = await dbResponse.json();
        
        if (config.name === 'javaAgent' || config.name === 'orchestration') {
          db = dbData.components?.db?.status === 'UP' ? 'Healthy' : 
               (dbData.components?.db ? 'Unhealthy' : 'N/A');
        } else if (config.name === 'java') {
          // Java后端数据库状态解析
          db = dbData.status === 'Database connection: Healthy' ? 'Healthy' : 'Unhealthy';
        } else if (config.name === 'rust') {
          // Rust后端数据库状态解析
          db = dbData.status === 'Database connection: Healthy (simulated)' ? 'Healthy' : 'Unhealthy';
        } else {
          db = dbData.status || 'Healthy';
        }
      } catch (error) {
        db = 'Unhealthy';
      }
    } else {
      // 如果没有数据库健康检查端点，使用服务状态
      db = status === 'Healthy' ? 'Healthy' : 'Unhealthy';
    }
    
    return { status, db };
  } catch (error) {
    console.error(`Health check failed for ${config.name}:`, error);
    return { status: 'Unhealthy', db: 'Unhealthy' };
  }
}

export const serviceConfigs: ServiceConfig[] = [
  {
    name: 'rust',
    title: 'Rust后端服务',
    healthEndpoint: '/api/rust/health',  // 使用代理路径
    dbHealthEndpoint: '/api/rust/db-health'  // 使用代理路径
  },
  {
    name: 'java',
    title: 'Java后端服务',
    healthEndpoint: '/api/java/health',  // 使用代理路径
    dbHealthEndpoint: '/api/java/db-health'  // 使用代理路径
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
