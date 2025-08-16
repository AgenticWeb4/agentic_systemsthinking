#!/bin/bash

# 系统思维智能体项目 - 服务测试脚本

echo "🧪 开始测试系统思维智能体项目服务..."

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 10

# 测试函数
test_service() {
    local service_name=$1
    local url=$2
    local description=$3
    
    echo "🔍 测试 $service_name ($description)..."
    
    if curl -s "$url" > /dev/null; then
        echo "✅ $service_name 运行正常"
        return 0
    else
        echo "❌ $service_name 测试失败"
        return 1
    fi
}

# 测试数据库连接
test_database() {
    local service_name=$1
    local url=$2
    
    echo "🔍 测试 $service_name 数据库连接..."
    
    if curl -s "$url" > /dev/null; then
        echo "✅ $service_name 数据库连接正常"
        return 0
    else
        echo "❌ $service_name 数据库连接失败"
        return 1
    fi
}

# 测试所有服务
echo "📡 测试服务健康状态..."
test_service "Rust后端" "http://localhost:8001/health" "端口8001"
test_service "Java后端" "http://localhost:8002/health" "端口8002"
test_service "智能体系统" "http://localhost:8003/health" "端口8003"
test_service "GUI应用" "http://localhost:3000" "端口3000"

echo ""
echo "🗄️ 测试数据库连接..."
test_database "Rust后端" "http://localhost:8001/db-health"
test_database "Java后端" "http://localhost:8002/db-health"
test_database "智能体系统" "http://localhost:8003/db-health"

echo ""
echo "🔗 测试服务间通信..."
echo "Rust后端检查其他服务:"
curl -s "http://localhost:8001/check-services" | jq . 2>/dev/null || echo "  响应格式: $(curl -s http://localhost:8001/check-services)"

echo "Java后端检查其他服务:"
curl -s "http://localhost:8002/check-services" | jq . 2>/dev/null || echo "  响应格式: $(curl -s http://localhost:8002/check-services)"

echo "智能体系统检查其他服务:"
curl -s "http://localhost:8003/check-services" | jq . 2>/dev/null || echo "  响应格式: $(curl -s http://localhost:8003/check-services)"

echo ""
echo "📊 测试完成！"
echo "如果所有测试都通过，说明系统运行正常。"
echo "如果有测试失败，请检查服务日志: make logs"
