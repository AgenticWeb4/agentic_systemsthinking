<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  
  export let title: string;
  export let status: string;
  export let dbStatus: string;
  export let loading: boolean = false;
  export let theme: 'light' | 'dark' = 'light';
  
  const dispatch = createEventDispatcher();
  
  $: statusColor = status === 'Healthy' ? 'text-green-600' : 'text-red-600';
  $: dbStatusColor = dbStatus === 'Healthy' ? 'text-green-600' : 
                     dbStatus === 'N/A' ? 'text-gray-500' : 'text-red-600';
  
  $: cardClasses = theme === 'dark' 
    ? 'bg-gray-800 border-gray-700 text-white' 
    : 'bg-white border-gray-200 text-gray-800';
  
  $: titleClasses = theme === 'dark' ? 'text-gray-200' : 'text-gray-700';
  $: labelClasses = theme === 'dark' ? 'text-gray-400' : 'text-gray-600';
</script>

<div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 p-6 transition-all duration-300 hover:shadow-xl hover:scale-[1.02]">
  <h2 class="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-200">
    {title}
  </h2>
  
  {#if loading}
    <div class="space-y-3">
      <div class="flex items-center space-x-2">
        <div class="w-3 h-3 bg-gray-300 dark:bg-gray-600 rounded-full animate-pulse"></div>
        <span class="text-gray-500 dark:text-gray-400">检查中...</span>
      </div>
    </div>
  {:else}
    <div class="space-y-3">
      <div class="flex justify-between items-center">
        <span class="text-gray-600 dark:text-gray-400">服务状态:</span>
        <div class="flex items-center space-x-2">
          <div class="w-2 h-2 rounded-full {status === 'Healthy' ? 'bg-green-500' : 'bg-red-500'}"></div>
          <span class="font-medium {statusColor}">
            {status}
          </span>
        </div>
      </div>
      
      <div class="flex justify-between items-center">
        <span class="text-gray-600 dark:text-gray-400">数据库:</span>
        <div class="flex items-center space-x-2">
          <div class="w-2 h-2 rounded-full {dbStatus === 'Healthy' ? 'bg-green-500' : dbStatus === 'N/A' ? 'bg-gray-400' : 'bg-red-500'}"></div>
          <span class="font-medium {dbStatusColor}">
            {dbStatus}
          </span>
        </div>
      </div>
    </div>
  {/if}
</div>
