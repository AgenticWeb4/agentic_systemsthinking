#!/bin/bash

# Docker状态检查脚本

echo "🔍 检查Docker状态..."

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker"
    exit 1
fi

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker守护进程未运行"
    echo ""
    echo "请执行以下操作之一："
    echo "1. 启动Docker Desktop应用程序"
    echo "2. 或者在终端运行: sudo systemctl start docker (Linux)"
    echo "3. 或者在终端运行: open -a Docker (macOS)"
    echo ""
    echo "等待Docker启动完成后，再次运行此脚本"
    exit 1
fi

echo "✅ Docker运行正常"
echo "Docker版本: $(docker --version)"
echo "Docker Compose版本: $(docker-compose --version)"

# 检查端口占用
echo ""
echo "🔍 检查端口占用..."
check_port() {
    local port=$1
    local service=$2
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "⚠️  端口 $port 已被占用 ($service)"
        return 1
    else
        echo "✅ 端口 $port 可用"
        return 0
    fi
}

check_port 3000 "GUI应用"
check_port 8001 "Rust后端"
check_port 8002 "Java后端"
check_port 8003 "智能体系统"
check_port 5432 "PostgreSQL"
check_port 6379 "Redis"

echo ""
echo "🎉 Docker环境检查完成！"
echo "现在可以运行: make dev"
