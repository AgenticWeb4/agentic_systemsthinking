// 服务状态枚举
export type ServiceHealthStatus = 'Healthy' | 'Unhealthy' | 'Checking...';
export type DatabaseHealthStatus = 'Healthy' | 'Unhealthy' | 'N/A';

// 服务状态接口
export interface ServiceStatus {
  status: ServiceHealthStatus;
  db: DatabaseHealthStatus;
  lastChecked?: Date;
  responseTime?: number;
}

// 服务配置接口
export interface ServiceConfig {
  name: ServiceName;
  title: string;
  healthEndpoint: string;
  dbHealthEndpoint?: string;
  timeout?: number;
  retryAttempts?: number;
}

// 服务名称联合类型
export type ServiceName = 'gui' | 'rust' | 'java' | 'agent' | 'javaAgent' | 'orchestration';

// 服务集合接口
export interface Services {
  gui: ServiceStatus;
  rust: ServiceStatus;
  java: ServiceStatus;
  agent: ServiceStatus;
  javaAgent: ServiceStatus;
  orchestration: ServiceStatus;
}

// 健康检查结果接口
export interface HealthCheckResult {
  service: ServiceName;
  status: ServiceStatus;
  success: boolean;
  error?: string;
  timestamp: Date;
}

// 健康检查配置接口
export interface HealthCheckConfig {
  timeout: number;
  retryAttempts: number;
  checkInterval: number;
  autoRefresh: boolean;
}
