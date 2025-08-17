import { writable, derived } from 'svelte/store';
import type { Services, ServiceStatus, ServiceName, HealthCheckResult } from '$lib/types/service';
import { checkServiceHealth, serviceConfigs } from '$lib/utils/healthCheck';

// 初始服务状态
const initialServices: Services = {
  gui: { status: 'Checking...', db: 'Checking...' },
  rust: { status: 'Checking...', db: 'Checking...' },
  java: { status: 'Checking...', db: 'Checking...' },
  agent: { status: 'Checking...', db: 'Checking...' },
  javaAgent: { status: 'Checking...', db: 'Checking...' },
  orchestration: { status: 'Checking...', db: 'Checking...' }
};

// 创建服务状态store
export const services = writable<Services>(initialServices);

// 创建加载状态store
export const loading = writable<boolean>(true);
export const refreshing = writable<boolean>(false);

// 创建错误状态store
export const errors = writable<Map<ServiceName, string>>(new Map());

// 创建最后更新时间store
export const lastUpdated = writable<Date | null>(null);

// 计算总体健康状态
export const overallHealth = derived(services, ($services) => {
  const serviceEntries = Object.entries($services).filter(([key]) => key !== 'gui');
  const healthyCount = serviceEntries.filter(([, service]) => service.status === 'Healthy').length;
  const totalCount = serviceEntries.length;
  
  if (totalCount === 0) return 'Unknown';
  if (healthyCount === totalCount) return 'All Healthy';
  if (healthyCount === 0) return 'All Unhealthy';
  return `${healthyCount}/${totalCount} Healthy`;
});

// 检查单个服务健康状态
export async function checkService(serviceName: ServiceName): Promise<void> {
  try {
    const config = serviceConfigs.find(c => c.name === serviceName);
    if (!config) {
      console.error(`Service config not found for: ${serviceName}`);
      return;
    }

    const result = await checkServiceHealth(config);
    
    if (result.success) {
      services.update(current => ({
        ...current,
        [serviceName]: result.status
      }));
      errors.update(current => {
        current.delete(serviceName);
        return current;
      });
    } else {
      services.update(current => ({
        ...current,
        [serviceName]: { status: 'Unhealthy', db: 'Unhealthy' }
      }));
      errors.update(current => {
        current.set(serviceName, result.error || 'Unknown error');
        return current;
      });
    }
  } catch (error) {
    console.error(`Failed to check service ${serviceName}:`, error);
    errors.update(current => {
      current.set(serviceName, error instanceof Error ? error.message : 'Unknown error');
      return current;
    });
  }
}

// 检查所有服务健康状态
export async function checkAllServices(): Promise<void> {
  try {
    loading.set(true);
    refreshing.set(true);
    
    // 并行检查所有服务
    const healthPromises = serviceConfigs.map(config => 
      checkServiceHealth(config).then(result => ({ name: config.name, result }))
    );
    
    const results = await Promise.all(healthPromises);
    
    // 更新服务状态
    const newServices = { ...initialServices };
    results.forEach(({ name, result }) => {
      if (result.success) {
        newServices[name] = result.status;
      } else {
        newServices[name] = { status: 'Unhealthy', db: 'Unhealthy' };
        errors.update(current => {
          current.set(name, result.error || 'Unknown error');
          return current;
        });
      }
    });
    
    // GUI服务总是健康的
    newServices.gui = { status: 'Healthy', db: 'Healthy' };
    
    services.set(newServices);
    lastUpdated.set(new Date());
    
  } catch (error) {
    console.error('Service health check failed:', error);
    errors.update(current => {
      current.set('gui' as ServiceName, 'Failed to check services');
      return current;
    });
  } finally {
    loading.set(false);
    refreshing.set(false);
  }
}

// 刷新单个服务
export async function refreshService(serviceName: ServiceName): Promise<void> {
  await checkService(serviceName);
  lastUpdated.set(new Date());
}

// 重置所有服务状态
export function resetServices(): void {
  services.set(initialServices);
  errors.set(new Map());
  lastUpdated.set(null);
  loading.set(false);
  refreshing.set(false);
}

// 获取服务状态摘要
export const serviceSummary = derived(services, ($services) => {
  const summary = {
    total: 0,
    healthy: 0,
    unhealthy: 0,
    checking: 0
  };
  
  Object.values($services).forEach(service => {
    summary.total++;
    switch (service.status) {
      case 'Healthy':
        summary.healthy++;
        break;
      case 'Unhealthy':
        summary.unhealthy++;
        break;
      case 'Checking...':
        summary.checking++;
        break;
    }
  });
  
  return summary;
});
