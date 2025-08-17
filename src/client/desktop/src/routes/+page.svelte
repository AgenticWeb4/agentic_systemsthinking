<script lang="ts">
  import { onMount, onDestroy } from 'svelte';
  import { theme } from '$lib/stores/theme';
  import StatusCard from '$lib/components/StatusCard.svelte';
  import ThemeToggle from '$lib/components/ThemeToggle.svelte';
  import LoadingSpinner from '$lib/components/LoadingSpinner.svelte';
  import RefreshButton from '$lib/components/RefreshButton.svelte';
  import SystemResources from '$lib/components/SystemResources.svelte';
  import QuickActions from '$lib/components/QuickActions.svelte';
import Notification from '$lib/components/Notification.svelte';
  
  
// 导入重构后的store
  import { 
    services, 
    loading, 
    refreshing, 
    overallHealth, 
    serviceSummary,
    lastUpdated,
    checkAllServices, 
    refreshService 
  } from '$lib/stores/services';
  
  import { notify, notifications, removeNotification } from '$lib/stores/notifications';
  
  let autoRefreshInterval: number;
  
  async function handleRefresh() {
    await checkAllServices();
    notify.success('刷新完成', '服务状态已更新');
  }
  
  function handleQuickAction(action: string) {
    switch (action) {
      case 'restart-all':
        notify.warning('重启服务', '正在重启所有服务...');
        break;
      case 'view-logs':
        notify.info('查看日志', '日志查看功能开发中...');
        break;
      case 'system-info':
        notify.info('系统信息', '系统信息功能开发中...');
        break;
      case 'settings':
        notify.info('设置', '设置功能开发中...');
        break;
      default:
        notify.info('操作', `执行操作: ${action}`);
    }
  }
  
  onMount(() => {
    // 初始检查
    checkAllServices();
    
    // 每30秒自动检查一次服务健康状态
    autoRefreshInterval = setInterval(checkAllServices, 30000);
  });
  
  onDestroy(() => {
    if (autoRefreshInterval) {
      clearInterval(autoRefreshInterval);
    }
  });
</script>

<svelte:head>
  <title>系统思维智能体项目 - 服务健康状态</title>
  <meta name="description" content="系统思维智能体项目服务监控仪表板" />
</svelte:head>

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
      
      <!-- 总体健康状态 -->
      <div class="mt-4">
        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200">
          {$overallHealth}
        </span>
      </div>
      
      <!-- 最后更新时间 -->
      {#if $lastUpdated}
        <div class="mt-2 text-sm text-gray-500 dark:text-gray-400">
          最后更新: {$lastUpdated.toLocaleTimeString()}
        </div>
      {/if}
    </div>
    
    <!-- 服务状态摘要 -->
    <div class="mb-6 p-4 bg-white dark:bg-gray-800 rounded-lg shadow-sm">
      <div class="flex flex-wrap justify-center gap-4 text-sm">
        <span class="text-gray-600 dark:text-gray-400">
          总计: <span class="font-semibold">{$serviceSummary.total}</span>
        </span>
        <span class="text-green-600 dark:text-green-400">
          健康: <span class="font-semibold">{$serviceSummary.healthy}</span>
        </span>
        <span class="text-red-600 dark:text-red-400">
          异常: <span class="font-semibold">{$serviceSummary.unhealthy}</span>
        </span>
        <span class="text-yellow-600 dark:text-yellow-400">
          检查中: <span class="font-semibold">{$serviceSummary.checking}</span>
        </span>
      </div>
    </div>
    
    <!-- 服务状态网格 -->
    {#if $loading}
      <div class="flex justify-center items-center py-20">
        <LoadingSpinner size="lg" theme={$theme} />
      </div>
    {:else}
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
        <!-- GUI服务 -->
        <StatusCard
          title="GUI服务"
          status={$services.gui.status}
          dbStatus={$services.gui.db}
          theme={$theme}
        />
        
        <!-- Rust后端服务 -->
        <StatusCard
          title="Rust后端服务"
          status={$services.rust.status}
          dbStatus={$services.rust.db}
          theme={$theme}
        />
        
        <!-- Java后端服务 -->
        <StatusCard
          title="Java后端服务"
          status={$services.java.status}
          dbStatus={$services.java.db}
          theme={$theme}
        />
        
        <!-- Python智能体系统 -->
        <StatusCard
          title="Python智能体系统"
          status={$services.agent.status}
          dbStatus={$services.agent.db}
          theme={$theme}
        />
        
        <!-- Java智能体系统 -->
        <StatusCard
          title="Java智能体系统"
          status={$services.javaAgent.status}
          dbStatus={$services.javaAgent.db}
          theme={$theme}
        />
        
        <!-- 编排服务 -->
        <StatusCard
          title="编排服务"
          status={$services.orchestration.status}
          dbStatus={$services.orchestration.db}
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
        loading={$refreshing} 
        on:refresh={handleRefresh}
      />
    </div>
    
    <!-- 系统信息 -->
    <div class="text-center">
      <div class="inline-flex items-center space-x-2 text-sm text-gray-500 dark:text-gray-400">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
        <span>自动刷新间隔: 30秒</span>
        <span>•</span>
        <span>最后更新: {$lastUpdated ? $lastUpdated.toLocaleTimeString() : '未更新'}</span>
      </div>
    </div>
  </div>
</main>

<!-- 通知系统 -->
<div class="fixed top-4 right-4 z-50 space-y-2">
  {#each $notifications as notification (notification.id)}
    <Notification
      id={notification.id}
      type={notification.type}
      title={notification.title}
      message={notification.message}
      timestamp={notification.timestamp}
      actions={notification.actions}
      on:close={(e) => removeNotification(e.detail.id)}
    />
  {/each}
</div>
