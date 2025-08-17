#!/bin/bash

# 系统思维智能体项目 - 服务测试脚本
# 重构版本：使用通用函数库和配置

set -euo pipefail

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 导入通用函数库和配置
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../config/services.conf"

# 脚本信息
SCRIPT_NAME="test-services.sh"
SCRIPT_VERSION="2.0.0"
SCRIPT_DESCRIPTION="测试Agentic System服务健康状态"

# 显示脚本信息
log_section "Agentic System - 服务测试脚本"
log_info "版本: $SCRIPT_VERSION"
log_info "描述: $SCRIPT_DESCRIPTION"

# 测试函数
test_service() {
    local service_name=$1
    local url=$2
    local description=$3
    
    log_info "测试 $service_name ($description)..."
    
    if curl -s "$url" > /dev/null; then
        log_success "$service_name 运行正常"
        return 0
    else
        log_error "$service_name 测试失败"
        return 1
    fi
}

# 测试数据库连接
test_database() {
    local service_name=$1
    local url=$2
    
    if [ -z "$url" ]; then
        log_warning "$service_name 没有数据库健康检查端点"
        return 0
    fi
    
    log_info "测试 $service_name 数据库连接..."
    
    if curl -s "$url" > /dev/null; then
        log_success "$service_name 数据库连接正常"
        return 0
    else
        log_error "$service_name 数据库连接失败"
        return 1
    fi
}

# 主函数
main() {
    # 等待服务启动
    log_info "等待服务启动..."
    sleep 10
    
    # 测试所有服务
    log_section "测试服务健康状态"
    local test_results=()
    
    # 测试核心服务
    for service in "${CORE_SERVICES[@]}"; do
        if [[ "$service" =~ ^(postgres|redis)$ ]]; then
            continue  # 跳过数据库服务，它们由Docker管理
        fi
        
        local port=$(get_service_port "$service")
        local name=$(get_service_name "$service")
        local health_endpoint=$(get_health_endpoint "$service")
        
        if [ -n "$health_endpoint" ]; then
            local url="http://localhost:$port$health_endpoint"
            if test_service "$name" "$url" "端口$port"; then
                test_results+=("$service:✅")
            else
                test_results+=("$service:❌")
            fi
        fi
    done
    
    # 测试前端应用
    if test_service "Svelte Frontend" "http://localhost:3000" "端口3000"; then
        test_results+=("frontend:✅")
    else
        test_results+=("frontend:❌")
    fi
    
    # 测试数据库连接
    log_section "测试数据库连接"
    for service in "${CORE_SERVICES[@]}"; do
        if [[ "$service" =~ ^(postgres|redis)$ ]]; then
            continue  # 跳过数据库服务
        fi
        
        local port=$(get_service_port "$service")
        local name=$(get_service_name "$service")
        local db_endpoint=$(get_db_health_endpoint "$service")
        
        if [ -n "$db_endpoint" ]; then
            local url="http://localhost:$port$db_endpoint"
            test_database "$name" "$url"
        fi
    done
    
    # 显示测试结果
    log_section "测试结果摘要"
    for result in "${test_results[@]}"; do
        echo "  $result"
    done
    
    # 显示总结
    show_final_status
}

# 显示最终状态
show_final_status() {
    echo ""
    log_success "服务测试完成！"
    log_info "如果所有测试都通过，说明系统运行正常。"
    log_info "如果有测试失败，请检查服务日志: make logs"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
