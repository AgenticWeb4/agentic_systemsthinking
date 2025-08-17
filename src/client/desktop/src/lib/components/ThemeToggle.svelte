<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  
  export let theme: 'light' | 'dark' = 'light';
  
  const dispatch = createEventDispatcher();
  
  function toggleTheme() {
    const newTheme = theme === 'light' ? 'dark' : 'light';
    dispatch('themeChange', newTheme);
  }
</script>

<button
  on:click={toggleTheme}
  class="fixed top-4 right-4 z-50 p-3 rounded-full bg-white dark:bg-gray-800 shadow-lg border border-gray-200 dark:border-gray-700 transition-all duration-300 hover:shadow-xl hover:scale-110"
  aria-label="切换主题"
>
  {#if theme === 'light'}
    <!-- 月亮图标 - 暗色主题 -->
    <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"></path>
    </svg>
  {:else}
    <!-- 太阳图标 - 亮色主题 -->
    <svg class="w-6 h-6 text-yellow-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"></path>
    </svg>
  {/if}
</button>
