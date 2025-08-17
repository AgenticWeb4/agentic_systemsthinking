<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { fade, fly } from 'svelte/transition';
  
  export let type: 'info' | 'success' | 'warning' | 'error' = 'info';
  export let title: string;
  export let message: string;
  export let show: boolean = false;
  export let duration: number = 5000;
  
  const dispatch = createEventDispatcher();
  
  let timeoutId: number;
  
  $: if (show && duration > 0) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => {
      dispatch('close');
    }, duration);
  }
  
  function handleClose() {
    dispatch('close');
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

{#if show}
  <div
    class="fixed top-4 right-4 z-50 max-w-sm w-full"
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
          <h3 class="text-sm font-medium {textClass}">
            {title}
          </h3>
          <p class="mt-1 text-sm text-gray-600 dark:text-gray-300">
            {message}
          </p>
        </div>
        
        <button
          on:click={handleClose}
          class="flex-shrink-0 ml-2 text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 transition-colors"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>
    </div>
  </div>
{/if}
