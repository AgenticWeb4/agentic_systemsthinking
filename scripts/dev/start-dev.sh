#!/bin/bash

# 系统思维智能体项目 - 开发环境启动脚本

echo "🚀 启动系统思维智能体项目开发环境..."

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker未运行，请先启动Docker Desktop"
    echo "   在macOS上，请打开Docker Desktop应用程序"
    echo "   等待Docker启动完成后，再次运行此脚本"
    exit 1
fi

echo "✅ Docker运行正常"

# 检查必要的端口是否被占用
check_port() {
    local port=$1
    local service=$2
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "❌ 端口 $port 已被占用，请停止 $service 服务"
        exit 1
    fi
}

echo "🔍 检查端口占用..."
check_port 3000 "GUI应用"
check_port 8001 "Rust后端"
check_port 8002 "Java后端"
check_port 8003 "智能体系统"
check_port 5432 "PostgreSQL"
check_port 6379 "Redis"

echo "✅ 端口检查通过"

# 创建必要的目录
echo "📁 创建必要的目录..."
mkdir -p logs
mkdir -p apps/agent-system/logs

# 启动开发环境
echo "🐳 启动Docker容器..."

# 检查环境变量文件
if [ -f ".env" ]; then
    echo "📋 加载 .env 文件..."
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "📋 使用默认环境配置..."
fi

docker-compose up -d --build

if [ $? -eq 0 ]; then
    echo "✅ 开发环境启动成功！"
    echo ""
    echo "🌐 服务地址:"
    echo "   GUI应用: http://localhost:3000"
    echo "   Rust后端: http://localhost:8001"
    echo "   Java后端: http://localhost:8002"
    echo "   智能体系统: http://localhost:8003"
    echo "   PostgreSQL: localhost:5432"
    echo "   Redis: localhost:6379"
    echo ""
    echo "📋 可用命令:"
    echo "   查看日志: make logs"
    echo "   健康检查: make health-check"
    echo "   服务状态: make status"
    echo "   停止服务: make dev-stop"
    echo ""
    echo "🎉 开始开发吧！"
else
    echo "❌ 开发环境启动失败"
    echo "请检查错误日志并修复问题"
    exit 1
fi
