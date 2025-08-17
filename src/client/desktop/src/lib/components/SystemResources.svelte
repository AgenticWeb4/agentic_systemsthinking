<script lang="ts">
  import { onMount } from 'svelte';
  
  export let theme: 'light' | 'dark' = 'light';
  
  let resources = {
    cpu: 0,
    memory: 0,
    disk: 0,
    network: 0
  };
  
  let loading = true;
  
  // 模拟系统资源数据
  function updateResources() {
    resources = {
      cpu: Math.floor(Math.random() * 100),
      memory: Math.floor(Math.random() * 100),
      disk: Math.floor(Math.random() * 100),
      network: Math.floor(Math.random() * 100)
    };
    loading = false;
  }
  
  $: cpuColor = resources.cpu > 80 ? 'text-red-600' : resources.cpu > 60 ? 'text-yellow-600' : 'text-green-600';
  $: memoryColor = resources.memory > 80 ? 'text-red-600' : resources.memory > 60 ? 'text-yellow-600' : 'text-green-600';
  $: diskColor = resources.disk > 80 ? 'text-red-600' : resources.disk > 60 ? 'text-yellow-600' : 'text-green-600';
  $: networkColor = resources.network > 80 ? 'text-red-600' : resources.network > 60 ? 'text-yellow-600' : 'text-green-600';
  
  onMount(() => {
    updateResources();
    // 每5秒更新一次资源使用情况
    const interval = setInterval(updateResources, 5000);
    return () => clearInterval(interval);
  });
</script>

<div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 p-6">
  <h2 class="text-xl font-semibold text-gray-700 dark:text-gray-200 mb-4">系统资源监控</h2>
  
  {#if loading}
    <div class="space-y-4">
      <div class="animate-pulse">
        <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-3/4"></div>
      </div>
      <div class="animate-pulse">
        <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/2"></div>
      </div>
    </div>
  {:else}
    <div class="space-y-4">
      <!-- CPU使用率 -->
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-3">
          <svg class="w-5 h-5 text-gray-500 dark:text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"></path>
          </svg>
          <span class="text-gray-600 dark:text-gray-400">CPU使用率</span>
        </div>
        <div class="flex items-center space-x-2">
          <div class="w-20 bg-gray-200 dark:bg-gray-700 rounded-full h-2">
            <div class="bg-blue-600 h-2 rounded-full transition-all duration-300" style="width: {resources.cpu}%"></div>
          </div>
          <span class="font-medium {cpuColor} w-12 text-right">{resources.cpu}%</span>
        </div>
      </div>
      
      <!-- 内存使用率 -->
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-3">
          <svg class="w-5 h-5 text-gray-500 dark:text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4"></path>
          </svg>
          <span class="text-gray-600 dark:text-gray-400">内存使用率</span>
        </div>
        <div class="flex items-center space-x-2">
          <div class="w-20 bg-gray-200 dark:bg-gray-700 rounded-full h-2">
            <div class="bg-green-600 h-2 rounded-full transition-all duration-300" style="width: {resources.memory}%"></div>
          </div>
          <span class="font-medium {memoryColor} w-12 text-right">{resources.memory}%</span>
        </div>
      </div>
      
      <!-- 磁盘使用率 -->
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-3">
          <svg class="w-5 h-5 text-gray-500 dark:text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4"></path>
          </svg>
          <span class="text-gray-600 dark:text-gray-400">磁盘使用率</span>
        </div>
        <div class="flex items-center space-x-2">
          <div class="w-20 bg-gray-200 dark:bg-gray-700 rounded-full h-2">
            <div class="bg-purple-600 h-2 rounded-full transition-all duration-300" style="width: {resources.disk}%"></div>
          </div>
          <span class="font-medium {diskColor} w-12 text-right">{resources.disk}%</span>
        </div>
      </div>
      
      <!-- 网络使用率 -->
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-3">
          <svg class="w-5 h-5 text-gray-500 dark:text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.111 16.404a5.5 5.5 0 017.778 0M12 20h.01m-7.08-7.071c3.904-3.905 10.236-3.905 14.141 0M1.394 9.393c5.857-5.857 15.355-5.857 21.213 0"></path>
          </svg>
          <span class="text-gray-600 dark:text-gray-400">网络使用率</span>
        </div>
        <div class="flex items-center space-x-2">
          <div class="w-20 bg-gray-200 dark:bg-gray-700 rounded-full h-2">
            <div class="bg-orange-600 h-2 rounded-full transition-all duration-300" style="width: {resources.network}%"></div>
          </div>
          <span class="font-medium {networkColor} w-12 text-right">{resources.network}%</span>
        </div>
      </div>
    </div>
  {/if}
</div>
