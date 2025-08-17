#!/bin/bash

# 测试各个服务的健康检查端点
# 重构版本：使用通用函数库和配置

set -euo pipefail

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 导入通用函数库和配置
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../config/services.conf"

# 脚本信息
SCRIPT_NAME="test-endpoints.sh"
SCRIPT_VERSION="2.0.0"
SCRIPT_DESCRIPTION="测试各个服务的健康检查端点"

# 显示脚本信息
log_section "Agentic System - 端点测试脚本"
log_info "版本: $SCRIPT_VERSION"
log_info "描述: $SCRIPT_DESCRIPTION"

# 测试服务端点
test_service_endpoint() {
    local service_name=$1
    local port=$2
    local endpoint=$3
    local description=$4
    
    log_info "🔍 $service_name (端口$port):"
    log_info "  $description:"
    
    if [ -n "$endpoint" ]; then
        local url="http://localhost:$port$endpoint"
        local response=$(curl -s "$url" 2>/dev/null || echo "连接失败")
        
        if command -v jq &> /dev/null; then
            echo "$response" | jq . 2>/dev/null || echo "  响应: $response"
        else
            echo "  响应: $response"
        fi
    else
        log_warning "  端点不存在"
    fi
    
    echo ""
}

# 主函数
main() {
    # 测试核心服务端点
    for service in "${CORE_SERVICES[@]}"; do
        if [[ "$service" =~ ^(postgres|redis)$ ]]; then
            continue  # 跳过数据库服务
        fi
        
        local port=$(get_service_port "$service")
        local name=$(get_service_name "$service")
        local health_endpoint=$(get_health_endpoint "$service")
        local db_endpoint=$(get_db_health_endpoint "$service")
        
        # 测试健康检查端点
        test_service_endpoint "$name" "$port" "$health_endpoint" "健康检查"
        
        # 测试数据库健康检查端点
        if [ -n "$db_endpoint" ]; then
            test_service_endpoint "$name" "$port" "$db_endpoint" "数据库健康检查"
        fi
    done
    
    # 测试前端应用
    log_info "🔍 Svelte Frontend (端口3000):"
    log_info "  页面访问:"
    local frontend_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>/dev/null || echo "连接失败")
    echo "  状态码: $frontend_status"
    
    # 显示总结
    show_final_status
}

# 显示最终状态
show_final_status() {
    echo ""
    log_success "端点测试完成！"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
