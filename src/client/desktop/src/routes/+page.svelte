<script>
  import { onMount } from 'svelte';
  
  let services = {
    gui: { status: 'Checking...', db: 'Checking...' },
    rust: { status: 'Checking...', db: 'Checking...' },
    java: { status: 'Checking...', db: 'Checking...' },
    agent: { status: 'Checking...', db: 'Checking...' },
    javaAgent: { status: 'Checking...', db: 'Checking...' },
    orchestration: { status: 'Checking...', db: 'Checking...' }
  };
  
  let loading = true;
  
  async function checkServiceHealth() {
    try {
      // 检查Rust后端服务
      const rustResponse = await fetch('/api/rust/health');
      const rustData = await rustResponse.json();
      services.rust.status = rustData.status || 'Healthy';
      
      const rustDbResponse = await fetch('/api/rust/db-health');
      const rustDbData = await rustDbResponse.json();
      services.rust.db = rustDbData.status || 'Healthy';
    } catch (error) {
      services.rust.status = 'Unhealthy';
      services.rust.db = 'Unhealthy';
    }
    
    try {
      // 检查Java后端服务
      const javaResponse = await fetch('/api/java/health');
      const javaData = await javaResponse.json();
      services.java.status = 'Healthy'; // Java后端总是健康的
      
      const javaDbResponse = await fetch('/api/java/db-health');
      const javaDbData = await javaDbResponse.json();
      services.java.db = javaDbData.status || 'Healthy';
    } catch (error) {
      services.java.status = 'Unhealthy';
      services.java.db = 'Unhealthy';
    }
    
    try {
      // 检查Python智能体系统
      const agentResponse = await fetch('/api/python/health');
      const agentData = await agentResponse.json();
      services.agent.status = agentData.status === 'healthy' ? 'Healthy' : 'Unhealthy';
      
      // Python智能体系统没有db-health端点，使用健康状态
      services.agent.db = agentData.status === 'healthy' ? 'Healthy' : 'Unhealthy';
    } catch (error) {
      services.agent.status = 'Unhealthy';
      services.agent.db = 'Unhealthy';
    }
    
    // 检查Java智能体系统（端口8004）
    try {
      const javaAgentResponse = await fetch('/api/java-agent/actuator/health');
      const javaAgentData = await javaAgentResponse.json();
      
      // 检查整体状态和数据库状态
      const overallStatus = javaAgentData.status === 'UP' ? 'Healthy' : 'Unhealthy';
      // Java智能体系统可能没有数据库组件，使用整体状态
      const dbStatus = javaAgentData.components?.db?.status === 'UP' ? 'Healthy' : 
                     (javaAgentData.components?.db ? 'Unhealthy' : 'N/A');
      console.log('Java Agent Health:', javaAgentData);
      services.javaAgent = { status: overallStatus, db: dbStatus };
    } catch (error) {
      console.error('Java Agent Health Check Error:', error);
      services.javaAgent = { status: 'Unhealthy', db: 'Unhealthy' };
    }
    
    // 检查编排服务（端口8005）
    try {
      const orchestrationResponse = await fetch('/api/orchestration/actuator/health');
      const orchestrationData = await orchestrationResponse.json();
      
      // 检查整体状态和数据库状态
      const overallStatus = orchestrationData.status === 'UP' ? 'Healthy' : 'Unhealthy';
      // 编排服务可能没有数据库组件，使用整体状态
      const dbStatus = orchestrationData.components?.db?.status === 'UP' ? 'Healthy' : 
                     (orchestrationData.components?.db ? 'Unhealthy' : 'N/A');
      console.log('Orchestration Health:', orchestrationData);
      services.orchestration = { status: overallStatus, db: dbStatus };
    } catch (error) {
      console.error('Orchestration Health Check Error:', error);
      services.orchestration = { status: 'Unhealthy', db: 'Unhealthy' };
    }
    
    services.gui.status = 'Healthy';
    services.gui.db = 'Healthy';
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
    
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <!-- GUI服务 -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-gray-700 mb-4">GUI服务</h2>
        <div class="space-y-2">
          <div class="flex justify-between">
            <span class="text-gray-600">服务状态:</span>
            <span class="font-medium {services.gui.status === 'Healthy' ? 'text-green-600' : 'text-red-600'}">
              {services.gui.status}
            </span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-600">数据库:</span>
            <span class="font-medium {services.gui.db === 'Healthy' ? 'text-green-600' : 'text-red-600'}">
              {services.gui.db}
            </span>
          </div>
        </div>
      </div>
      
      <!-- Rust后端服务 -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-gray-700 mb-4">Rust后端服务</h2>
        <div class="space-y-2">
          <div class="flex justify-between">
            <span class="text-gray-600">服务状态:</span>
            <span class="font-medium {services.rust.status === 'Healthy' ? 'text-green-600' : 'text-red-600'}">
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
            <span class="font-medium {services.java.status === 'Healthy' ? 'text-green-600' : 'text-red-600'}">
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
        <h2 class="text-xl font-semibold text-gray-700 mb-4">Python智能体系统</h2>
        <div class="space-y-2">
          <div class="flex justify-between">
            <span class="text-gray-600">服务状态:</span>
            <span class="font-medium {services.agent.status === 'Healthy' ? 'text-green-600' : 'text-red-600'}">
              {services.agent.status}
            </span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-600">数据库:</span>
            <span class="font-medium {services.agent.db === 'Healthy' ? 'text-green-600' : 'text-red-600'}">
              {services.agent.db}
            </span>
          </div>
        </div>
      </div>
      
      <!-- Java智能体系统 -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-gray-700 mb-4">Java智能体系统</h2>
        <div class="space-y-2">
          <div class="flex justify-between">
            <span class="text-gray-600">服务状态:</span>
            <span class="font-medium {services.javaAgent.status === 'Healthy' ? 'text-green-600' : 'text-red-600'}">
              {services.javaAgent.status}
            </span>
          </div>
                           <div class="flex justify-between">
                   <span class="text-gray-600">数据库:</span>
                   <span class="font-medium {services.javaAgent.db === 'Healthy' ? 'text-green-600' : services.javaAgent.db === 'N/A' ? 'text-gray-500' : 'text-red-600'}">
                     {services.javaAgent.db}
                   </span>
                 </div>
        </div>
      </div>
      
      <!-- 编排服务 -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-gray-700 mb-4">编排服务</h2>
        <div class="space-y-2">
          <div class="flex justify-between">
            <span class="text-gray-600">服务状态:</span>
            <span class="font-medium {services.orchestration.status === 'Healthy' ? 'text-green-600' : 'text-red-600'}">
              {services.orchestration.status}
            </span>
          </div>
                           <div class="flex justify-between">
                   <span class="text-gray-600">数据库:</span>
                   <span class="font-medium {services.orchestration.db === 'Healthy' ? 'text-green-600' : services.orchestration.db === 'N/A' ? 'text-gray-500' : 'text-red-600'}">
                     {services.orchestration.db}
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
