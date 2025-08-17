<script lang="ts">
  import { createEventDispatcher, onMount } from 'svelte';
  import { fade, fly } from 'svelte/transition';
  import type { NotificationType, NotificationAction } from '$lib/stores/notifications';
  
  export let id: string;
  export let type: NotificationType = 'info';
  export let title: string;
  export let message: string;
  export let timestamp: Date;
  export let actions: NotificationAction[] = [];
  
  const dispatch = createEventDispatcher();
  
  function handleClose() {
    dispatch('close', { id });
  }
  
  function handleAction(action: NotificationAction) {
    action.action();
    handleClose();
  }
  
  $: iconClass = {
    info: 'text-blue-500',
    success: 'text-green-500',
    warning: 'text-yellow-500',
    error: 'text-red-500'
  }[type];
  
  $: bgClass = {
    info: 'bg-blue-50 dark:bg-blue-900/20 border-blue-200 dark:border-blue-800',
    success: 'bg-green-50 dark:bg-green-900/20 border-green-200 dark:border-green-800',
    warning: 'bg-yellow-50 dark:bg-yellow-900/20 border-yellow-200 dark:border-yellow-800',
    error: 'bg-red-50 dark:bg-red-900/20 border-red-200 dark:border-red-800'
  }[type];
  
  $: textClass = {
    info: 'text-blue-800 dark:text-blue-200',
    success: 'text-green-800 dark:text-green-200',
    warning: 'text-yellow-800 dark:text-yellow-200',
    error: 'text-red-800 dark:text-red-200'
  }[type];
  
  $: icon = {
    info: `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>`,
    success: `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>`,
    warning: `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.34 16.5c-.77.833.192 2.5 1.732 2.5z"></path>`,
    error: `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>`
  }[type];
</script>

<div
  class="max-w-sm w-full"
  transition:fly={{ y: -50, duration: 300 }}
>
  <div class="border rounded-lg p-4 {bgClass} shadow-lg">
    <div class="flex items-start space-x-3">
      <div class="flex-shrink-0">
        <svg class="w-6 h-6 {iconClass}" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          {@html icon}
        </svg>
      </div>
      
      <div class="flex-1 min-w-0">
        <div class="flex items-center justify-between">
          <h3 class="text-sm font-medium {textClass}">
            {title}
          </h3>
          <span class="text-xs text-gray-500 dark:text-gray-400">
            {timestamp.toLocaleTimeString()}
          </span>
        </div>
        <p class="mt-1 text-sm text-gray-600 dark:text-gray-300">
          {message}
        </p>
        
        <!-- 操作按钮 -->
        {#if actions && actions.length > 0}
          <div class="mt-3 flex space-x-2">
            {#each actions as action}
              <button
                on:click={() => handleAction(action)}
                class="px-2 py-1 text-xs rounded border transition-colors {
                  action.variant === 'primary' ? 'bg-blue-500 text-white border-blue-500 hover:bg-blue-600' :
                  action.variant === 'danger' ? 'bg-red-500 text-white border-red-500 hover:bg-red-600' :
                  'bg-gray-100 text-gray-700 border-gray-300 hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-200 dark:border-gray-600 dark:hover:bg-gray-600'
                }"
              >
                {action.label}
              </button>
            {/each}
          </div>
        {/if}
      </div>
      
              <button
          on:click={handleClose}
          class="flex-shrink-0 ml-2 text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 transition-colors"
          aria-label="关闭通知"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
    </div>
  </div>
</div>
