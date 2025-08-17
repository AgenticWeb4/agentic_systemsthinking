<script lang="ts">
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let theme: 'light' | 'dark' = 'light';
  
  $: sizeClasses = {
    sm: 'w-4 h-4',
    md: 'w-8 h-8',
    lg: 'w-12 h-12'
  };
  
  $: colorClasses = theme === 'dark' ? 'border-gray-600 border-t-blue-500' : 'border-gray-300 border-t-blue-600';
</script>

<div class="flex flex-col items-center justify-center space-y-3">
  <div class="{sizeClasses[size]} animate-spin rounded-full border-2 border-solid {colorClasses}"></div>
  <p class="text-sm text-gray-600 dark:text-gray-400">正在检查服务健康状态...</p>
</div>
