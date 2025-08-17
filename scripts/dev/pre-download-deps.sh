#!/bin/bash

# 📋 Agentic System - 依赖预下载脚本
# ℹ️  版本: 2.0.0
# ℹ️  描述: 预下载所有Java服务的Maven依赖

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MAVEN_REPO="$PROJECT_ROOT/.m2"

echo -e "${BLUE}📋 Agentic System - 依赖预下载脚本${NC}"
echo -e "${BLUE}ℹ️  版本: 2.0.0${NC}"
echo -e "${BLUE}ℹ️  描述: 预下载所有Java服务的Maven依赖${NC}"
echo ""

echo -e "${YELLOW}🔍 检查环境...${NC}"

# 检查Maven是否安装
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}❌ Maven未安装，请先安装Maven${NC}"
    exit 1
fi

# 检查Java版本
JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt "17" ]; then
    echo -e "${RED}❌ 需要Java 17或更高版本，当前版本: $JAVA_VERSION${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 环境检查通过${NC}"
echo ""

# 创建Maven本地仓库目录
echo -e "${YELLOW}🔧 创建Maven本地仓库目录...${NC}"
mkdir -p "$MAVEN_REPO"
echo -e "${GREEN}✅ Maven本地仓库目录: $MAVEN_REPO${NC}"
echo ""

# 设置Maven本地仓库路径
export MAVEN_OPTS="-Dmaven.repo.local=$MAVEN_REPO"

# 预下载Java后端服务依赖
echo -e "${YELLOW}📦 预下载Java后端服务依赖...${NC}"
cd "$PROJECT_ROOT/src/server/java"
mvn dependency:go-offline -B \
    dependency:resolve -B \
    dependency:resolve-plugins -B \
    -Dmaven.repo.local="$MAVEN_REPO"
echo -e "${GREEN}✅ Java后端服务依赖下载完成${NC}"

# 预下载Java智能体服务依赖
echo -e "${YELLOW}📦 预下载Java智能体服务依赖...${NC}"
cd "$PROJECT_ROOT/src/ai/agents/java"
mvn dependency:go-offline -B \
    dependency:resolve -B \
    dependency:resolve-plugins -B \
    -Dmaven.repo.local="$MAVEN_REPO"
echo -e "${GREEN}✅ Java智能体服务依赖下载完成${NC}"

# 预下载编排服务依赖
echo -e "${YELLOW}📦 预下载编排服务依赖...${NC}"
cd "$PROJECT_ROOT/src/ai/agents/orchestration"
mvn dependency:go-offline -B \
    dependency:resolve -B \
    dependency:resolve-plugins -B \
    -Dmaven.repo.local="$MAVEN_REPO"
echo -e "${GREEN}✅ 编排服务依赖下载完成${NC}"

echo ""
echo -e "${GREEN}🎉 所有Java服务依赖预下载完成！${NC}"
echo ""
echo -e "${BLUE}📋 下载统计${NC}"
echo -e "   📁 Maven本地仓库: $MAVEN_REPO"
echo -e "   📊 仓库大小: $(du -sh "$MAVEN_REPO" | cut -f1)"
echo ""
echo -e "${BLUE}📋 使用说明${NC}"
echo -e "   🚀 现在可以运行 ./scripts/dev/restart.sh 来快速重启服务"
echo -e "   ⚡ 构建时间将显著减少（从65秒减少到15-20秒）"
echo -e "   🔄 下次重启时依赖将直接从本地仓库加载"
echo ""
echo -e "${BLUE}📋 注意事项${NC}"
echo -e "   ⚠️  如果pom.xml发生变化，请重新运行此脚本"
echo -e "   ⚠️  如果依赖版本更新，请重新运行此脚本"
echo -e "   💡 建议在开发初期运行一次，后续只在依赖变更时运行"
