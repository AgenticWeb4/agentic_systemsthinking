#!/bin/bash

# 环境切换脚本
# 用于在不同环境配置之间切换

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 显示帮助信息
show_help() {
    echo "🌍 环境切换脚本"
    echo ""
    echo "用法: $0 [环境名]"
    echo ""
    echo "可用环境:"
    echo "  dev     - 开发环境 (默认)"
    echo "  test    - 测试环境"
    echo "  prod    - 生产环境"
    echo ""
    echo "示例:"
    echo "  $0 dev      # 切换到开发环境"
    echo "  $0 test     # 切换到测试环境"
    echo "  $0 prod     # 切换到生产环境"
    echo ""
    echo "注意: 生产环境需要手动配置敏感信息"
}

# 切换到指定环境
switch_to_env() {
    local env=$1
    local source_file="configs/env/env.$env"
    local target_file=".env"
    
    if [ ! -f "$source_file" ]; then
        echo -e "${RED}❌ 环境配置文件不存在: $source_file${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}🔄 切换到 $env 环境...${NC}"
    
    # 备份当前 .env 文件
    if [ -f "$target_file" ]; then
        cp "$target_file" "$target_file.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}📋 已备份当前 .env 文件${NC}"
    fi
    
    # 复制环境配置
    cp "$source_file" "$target_file"
    echo -e "${GREEN}✅ 已切换到 $env 环境${NC}"
    
    # 显示配置摘要
    echo ""
    echo -e "${BLUE}📋 $env 环境配置摘要:${NC}"
    echo "数据库: $(grep 'POSTGRES_DB=' "$target_file" | cut -d'=' -f2)"
    echo "GUI端口: $(grep 'GUI_PORT=' "$target_file" | cut -d'=' -f2)"
    echo "Rust后端端口: $(grep 'RUST_BACKEND_PORT=' "$target_file" | cut -d'=' -f2)"
    echo "Java后端端口: $(grep 'JAVA_BACKEND_PORT=' "$target_file" | cut -d'=' -f2)"
    echo "智能体系统端口: $(grep 'AGENT_SYSTEM_PORT=' "$target_file" | cut -d'=' -f2)"
    
    if [ "$env" = "prod" ]; then
        echo ""
        echo -e "${YELLOW}⚠️  生产环境提醒:${NC}"
        echo "1. 请修改 .env 文件中的敏感信息 (密码、密钥等)"
        echo "2. 确保生产环境的安全配置"
        echo "3. 建议使用密钥管理服务"
    fi
    
    echo ""
    echo -e "${GREEN}🎉 环境切换完成！${NC}"
    echo "现在可以启动服务了:"
    echo "  ./start-dev.sh"
    echo "  或"
    echo "  make dev"
}

# 主逻辑
main() {
    local env=${1:-dev}
    
    case $env in
        dev|test|prod)
            switch_to_env "$env"
            ;;
        -h|--help|help)
            show_help
            ;;
        *)
            echo -e "${RED}❌ 无效的环境名: $env${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"
