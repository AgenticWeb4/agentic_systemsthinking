<script lang="ts">
  import { onMount } from 'svelte';
  import { theme } from '$lib/stores/theme';
  import StatusCard from '$lib/components/StatusCard.svelte';
  import ThemeToggle from '$lib/components/ThemeToggle.svelte';
  import LoadingSpinner from '$lib/components/LoadingSpinner.svelte';
  import RefreshButton from '$lib/components/RefreshButton.svelte';
  import SystemResources from '$lib/components/SystemResources.svelte';
  import QuickActions from '$lib/components/QuickActions.svelte';
  import Notification from '$lib/components/Notification.svelte';
  import type { Services } from '$lib/types/service';
  import { checkServiceHealth, serviceConfigs } from '$lib/utils/healthCheck';
  
  let services: Services = {
    gui: { status: 'Checking...', db: 'Checking...' },
    rust: { status: 'Checking...', db: 'Checking...' },
    java: { status: 'Checking...', db: 'Checking...' },
    agent: { status: 'Checking...', db: 'Checking...' },
    javaAgent: { status: 'Checking...', db: 'Checking...' },
    orchestration: { status: 'Checking...', db: 'Checking...' }
  };
  
  let loading = true;
  let refreshing = false;
  let notification = {
    show: false,
    type: 'info' as 'info' | 'success' | 'warning' | 'error',
    title: '',
    message: ''
  };
  
  async function checkAllServices() {
    try {
      // 并行检查所有服务
      const healthPromises = serviceConfigs.map(config => 
        checkServiceHealth(config).then(result => ({ name: config.name, result }))
      );
      
      const results = await Promise.all(healthPromises);
      
      // 更新服务状态
      results.forEach(({ name, result }) => {
        if (name in services) {
          services[name] = result;
        }
      });
      
      // GUI服务总是健康的
      services.gui = { status: 'Healthy', db: 'Healthy' };
      
      // 显示成功通知
      showNotification('success', '服务检查完成', '所有服务状态已更新');
      
    } catch (error) {
      console.error('Service health check failed:', error);
      showNotification('error', '服务检查失败', '无法获取服务状态信息');
    } finally {
      loading = false;
      refreshing = false;
    }
  }
  
  async function handleRefresh() {
    refreshing = true;
    await checkAllServices();
  }
  
  function handleQuickAction(action: string) {
    switch (action) {
      case 'restart-all':
        showNotification('warning', '重启服务', '正在重启所有服务...');
        break;
      case 'view-logs':
        showNotification('info', '查看日志', '日志查看功能开发中...');
        break;
      case 'system-info':
        showNotification('info', '系统信息', '系统信息功能开发中...');
        break;
      case 'settings':
        showNotification('info', '设置', '设置功能开发中...');
        break;
      default:
        showNotification('info', '操作', `执行操作: ${action}`);
    }
  }
  
  function showNotification(type: 'info' | 'success' | 'warning' | 'error', title: string, message: string) {
    notification = { show: true, type, title, message };
  }
  
  function hideNotification() {
    notification.show = false;
  }
  
  onMount(() => {
    checkAllServices();
    // 每30秒自动检查一次服务健康状态
    const interval = setInterval(checkAllServices, 30000);
    return () => clearInterval(interval);
  });
</script>

<svelte:head>
  <title>系统思维智能体项目 - 服务健康状态</title>
  <meta name="description" content="系统思维智能体项目服务监控仪表板" />
</svelte:head>

<!-- 通知组件 -->
<Notification
  bind:show={notification.show}
  type={notification.type}
  title={notification.title}
  message={notification.message}
  on:close={hideNotification}
/>

<!-- 主题切换按钮 -->
<ThemeToggle theme={$theme} on:themeChange={(e) => theme.set(e.detail)} />

<main class="min-h-screen bg-gray-50 dark:bg-gray-900 py-8 px-4 transition-colors duration-300">
  <div class="max-w-7xl mx-auto">
    <!-- 页面标题 -->
    <div class="text-center mb-12">
      <h1 class="text-4xl md:text-5xl font-bold text-gray-800 dark:text-white mb-4 transition-colors duration-300">
        系统思维智能体项目
      </h1>
      <p class="text-lg text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
        智能化的系统思维分析与决策支持平台
      </p>
    </div>
    
    <!-- 服务状态网格 -->
    {#if loading}
      <div class="flex justify-center items-center py-20">
        <LoadingSpinner size="lg" theme={$theme} />
      </div>
    {:else}
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
        <!-- GUI服务 -->
        <StatusCard
          title="GUI服务"
          status={services.gui.status}
          dbStatus={services.gui.db}
          theme={$theme}
        />
        
        <!-- Rust后端服务 -->
        <StatusCard
          title="Rust后端服务"
          status={services.rust.status}
          dbStatus={services.rust.db}
          theme={$theme}
        />
        
        <!-- Java后端服务 -->
        <StatusCard
          title="Java后端服务"
          status={services.java.status}
          dbStatus={services.java.db}
          theme={$theme}
        />
        
        <!-- Python智能体系统 -->
        <StatusCard
          title="Python智能体系统"
          status={services.agent.status}
          dbStatus={services.agent.db}
          theme={$theme}
        />
        
        <!-- Java智能体系统 -->
        <StatusCard
          title="Java智能体系统"
          status={services.javaAgent.status}
          dbStatus={services.javaAgent.db}
          theme={$theme}
        />
        
        <!-- 编排服务 -->
        <StatusCard
          title="编排服务"
          status={services.orchestration.status}
          dbStatus={services.orchestration.db}
          theme={$theme}
        />
      </div>
      
      <!-- 新增功能区域 -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <!-- 系统资源监控 -->
        <SystemResources theme={$theme} />
        
        <!-- 快速操作面板 -->
        <QuickActions theme={$theme} on:action={handleQuickAction} />
      </div>
    {/if}
    
    <!-- 操作按钮 -->
    <div class="text-center mb-8">
      <RefreshButton 
        loading={refreshing} 
        on:refresh={handleRefresh}
      />
    </div>
    
    <!-- 系统信息 -->
    <div class="text-center">
      <div class="inline-flex items-center space-x-2 text-sm text-gray-500 dark:text-gray-400">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
        <span>自动刷新间隔: 30秒</span>
        <span>•</span>
        <span>最后更新: {new Date().toLocaleTimeString()}</span>
      </div>
    </div>
  </div>
</main>
