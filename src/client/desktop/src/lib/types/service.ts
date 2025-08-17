export interface ServiceStatus {
  status: 'Healthy' | 'Unhealthy' | 'Checking...';
  db: 'Healthy' | 'Unhealthy' | 'Checking...' | 'N/A';
}

export interface Services {
  gui: ServiceStatus;
  rust: ServiceStatus;
  java: ServiceStatus;
  agent: ServiceStatus;
  javaAgent: ServiceStatus;
  orchestration: ServiceStatus;
}

export interface ServiceConfig {
  name: string;
  title: string;
  healthEndpoint: string;
  dbHealthEndpoint?: string;
}
