<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  
  export let loading: boolean = false;
  
  const dispatch = createEventDispatcher();
  
  function handleRefresh() {
    dispatch('refresh');
  }
</script>

<button
  on:click={handleRefresh}
  disabled={loading}
  class="inline-flex items-center px-6 py-3 bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white font-medium rounded-xl transition-all duration-300 hover:shadow-lg hover:scale-105 disabled:cursor-not-allowed disabled:transform-none"
>
  {#if loading}
    <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>
    刷新中...
  {:else}
    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
    </svg>
    刷新状态
  {/if}
</button>
