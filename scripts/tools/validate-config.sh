#!/bin/bash

# 配置验证脚本
# 验证系统思维智能体项目的配置完整性

set -e

echo "🔍 开始验证项目配置..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查函数
check_file() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅${NC} $description: $file"
        return 0
    else
        echo -e "${RED}❌${NC} $description: $file (缺失)"
        return 1
    fi
}

check_env_var() {
    local var=$1
    local description=$2
    
    if [ -n "${!var}" ]; then
        echo -e "${GREEN}✅${NC} $description: $var=${!var}"
        return 0
    else
        echo -e "${YELLOW}⚠️${NC} $description: $var (未设置)"
        return 1
    fi
}

# 检查必要文件
echo ""
echo "📁 检查必要文件..."
errors=0

check_file "env.example" "环境变量模板" || ((errors++))
check_file "configs/env/env.dev" "开发环境配置" || ((errors++))
check_file "infrastructure/docker-compose/dev.yml" "Docker Compose配置" || ((errors++))
check_file "infrastructure/docker-compose/init.sql" "数据库初始化脚本" || ((errors++))
check_file "Makefile" "项目构建脚本" || ((errors++))
check_file "start-dev.sh" "开发环境启动脚本" || ((errors++))
check_file "test-services.sh" "服务测试脚本" || ((errors++))

# 检查应用配置
echo ""
echo "🔧 检查应用配置..."
check_file "apps/gui/package.json" "GUI应用配置" || ((errors++))
check_file "apps/backend-rust/Cargo.toml" "Rust后端配置" || ((errors++))
check_file "apps/backend-java/pom.xml" "Java后端配置" || ((errors++))
check_file "apps/agent-system/requirements.txt" "智能体系统配置" || ((errors++))

# 检查Docker配置
echo ""
echo "🐳 检查Docker配置..."
check_file "infrastructure/docker/dev/Dockerfile.gui" "GUI应用Dockerfile" || ((errors++))
check_file "infrastructure/docker/dev/Dockerfile.rust" "Rust后端Dockerfile" || ((errors++))
check_file "infrastructure/docker/dev/Dockerfile.java" "Java后端Dockerfile" || ((errors++))
check_file "infrastructure/docker/dev/Dockerfile.agent" "智能体系统Dockerfile" || ((errors++))

# 检查环境变量
echo ""
echo "🌍 检查环境变量..."
if [ -f ".env" ]; then
    echo -e "${GREEN}✅${NC} 找到 .env 文件，加载环境变量..."
    source .env
    
    check_env_var "POSTGRES_DB" "数据库名称"
    check_env_var "POSTGRES_USER" "数据库用户名"
    check_env_var "POSTGRES_PASSWORD" "数据库密码"
    check_env_var "DATABASE_URL" "数据库连接URL"
    check_env_var "GUI_PORT" "GUI应用端口"
    check_env_var "RUST_BACKEND_PORT" "Rust后端端口"
    check_env_var "JAVA_BACKEND_PORT" "Java后端端口"
    check_env_var "AGENT_SYSTEM_PORT" "智能体系统端口"
else
    echo -e "${YELLOW}⚠️${NC} 未找到 .env 文件，使用默认配置"
    echo "建议复制 env.example 为 .env 并修改配置"
fi

# 检查端口占用
echo ""
echo "🔌 检查端口占用..."
ports=("3000" "8001" "8002" "8003" "5432" "6379")
for port in "${ports[@]}"; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️${NC} 端口 $port 已被占用"
    else
        echo -e "${GREEN}✅${NC} 端口 $port 可用"
    fi
done

# 检查Docker状态
echo ""
echo "🐳 检查Docker状态..."
if docker info > /dev/null 2>&1; then
    echo -e "${GREEN}✅${NC} Docker运行正常"
else
    echo -e "${RED}❌${NC} Docker未运行或无法连接"
    echo "请启动Docker Desktop应用程序"
    ((errors++))
fi

# 总结
echo ""
echo "📊 配置验证完成"
if [ $errors -eq 0 ]; then
    echo -e "${GREEN}🎉 所有配置检查通过！可以启动开发环境了。${NC}"
    echo ""
    echo "启动命令:"
    echo "  ./start-dev.sh"
    echo "  或"
    echo "  make dev"
else
    echo -e "${RED}❌ 发现 $errors 个配置问题，请修复后重试。${NC}"
    exit 1
fi
