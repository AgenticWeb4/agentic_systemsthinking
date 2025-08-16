<script>
  import { onMount } from 'svelte';
  
  let services = {
    gui: { status: 'Checking...', db: 'Checking...' },
    rust: { status: 'Checking...', db: 'Checking...' },
    java: { status: 'Checking...', db: 'Checking...' },
    agent: { status: 'Checking...', db: 'Checking...' }
  };
  
  let loading = true;
  
  async function checkServiceHealth() {
    try {
      // 检查Rust后端服务
      const rustResponse = await fetch('http://localhost:8001/health');
      services.rust.status = await rustResponse.text();
      
      const rustDbResponse = await fetch('http://localhost:8001/db-health');
      services.rust.db = await rustDbResponse.text();
    } catch (error) {
      services.rust.status = 'Unhealthy';
      services.rust.db = 'Unhealthy';
    }
    
    try {
      // 检查Java后端服务
      const javaResponse = await fetch('http://localhost:8002/health');
      services.java.status = await javaResponse.text();
      
      const javaDbResponse = await fetch('http://localhost:8002/db-health');
      services.java.db = await javaDbResponse.text();
    } catch (error) {
      services.java.status = 'Unhealthy';
      services.java.db = 'Unhealthy';
    }
    
    try {
      // 检查智能体系统
      const agentResponse = await fetch('http://localhost:8003/health');
      services.agent.status = await agentResponse.text();
      
      const agentDbResponse = await fetch('http://localhost:8003/db-health');
      services.agent.db = await agentDbResponse.text();
    } catch (error) {
      services.agent.status = 'Unhealthy';
      services.agent.db = 'Unhealthy';
    }
    
    services.gui.status = 'GUI Service Status: Healthy';
    services.gui.db = 'GUI Service Status: Healthy';
    loading = false;
  }
  
  onMount(() => {
    checkServiceHealth();
    // 每30秒检查一次服务健康状态
    const interval = setInterval(checkServiceHealth, 30000);
    return () => clearInterval(interval);
  });
</script>

<svelte:head>
  <title>系统思维智能体项目 - 服务健康状态</title>
</svelte:head>

<main class="min-h-screen bg-gray-100 py-8">
  <div class="max-w-4xl mx-auto px-4">
    <h1 class="text-3xl font-bold text-center text-gray-800 mb-8">
      系统思维智能体项目
    </h1>
    
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- GUI服务 -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-gray-700 mb-4">GUI服务</h2>
        <div class="space-y-2">
          <div class="flex justify-between">
            <span class="text-gray-600">服务状态:</span>
            <span class="font-medium text-green-600">{services.gui.status}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-600">数据库:</span>
            <span class="font-medium text-green-600">{services.gui.db}</span>
          </div>
        </div>
      </div>
      
      <!-- Rust后端服务 -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-gray-700 mb-4">Rust后端服务</h2>
        <div class="space-y-2">
          <div class="flex justify-between">
            <span class="text-gray-600">服务状态:</span>
            <span class="font-medium {services.rust.status.includes('Healthy') ? 'text-green-600' : 'text-red-600'}">
              {services.rust.status}
            </span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-600">数据库:</span>
            <span class="font-medium {services.rust.db.includes('Healthy') ? 'text-green-600' : 'text-red-600'}">
              {services.rust.db}
            </span>
          </div>
        </div>
      </div>
      
      <!-- Java后端服务 -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-gray-700 mb-4">Java后端服务</h2>
        <div class="space-y-2">
          <div class="flex justify-between">
            <span class="text-gray-600">服务状态:</span>
            <span class="font-medium {services.java.status.includes('Healthy') ? 'text-green-600' : 'text-red-600'}">
              {services.java.status}
            </span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-600">数据库:</span>
            <span class="font-medium {services.java.db.includes('Healthy') ? 'text-green-600' : 'text-red-600'}">
              {services.java.db}
            </span>
          </div>
        </div>
      </div>
      
      <!-- 智能体系统 -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-gray-700 mb-4">智能体系统</h2>
        <div class="space-y-2">
          <div class="flex justify-between">
            <span class="text-gray-600">服务状态:</span>
            <span class="font-medium {services.agent.status.includes('Healthy') ? 'text-green-600' : 'text-red-600'}">
              {services.agent.status}
            </span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-600">数据库:</span>
            <span class="font-medium {services.agent.db.includes('Healthy') ? 'text-green-600' : 'text-red-600'}">
              {services.agent.db}
            </span>
          </div>
        </div>
      </div>
    </div>
    
    {#if loading}
      <div class="text-center mt-8">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
        <p class="mt-2 text-gray-600">正在检查服务健康状态...</p>
      </div>
    {/if}
    
    <div class="text-center mt-8">
      <button 
        on:click={checkServiceHealth}
        class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition-colors"
      >
        刷新状态
      </button>
    </div>
  </div>
</main>
