#!/bin/bash

# 系统思维智能体项目 - 统一状态查看脚本
# 重构版本：使用通用函数库和配置

set -euo pipefail

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 导入通用函数库和配置
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../config/services.conf"

# 脚本信息
SCRIPT_NAME="status.sh"
SCRIPT_VERSION="2.0.0"
SCRIPT_DESCRIPTION="查看Agentic System状态"

# 显示脚本信息
log_section "Agentic System - 状态查看脚本"
log_info "版本: $SCRIPT_VERSION"
log_info "描述: $SCRIPT_DESCRIPTION"

# 检查Docker服务状态
check_docker_status() {
    log_section "Docker服务状态"
    
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker未运行"
        return 1
    fi
    
    # 显示容器状态
    if command -v docker-compose &> /dev/null; then
        docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
    else
        log_warning "docker-compose未安装"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    fi
}

# 检查前端应用状态
check_frontend_status() {
    log_section "前端应用状态"
    
    local frontend_pid_file="$LOGS_DIR/frontend.pid"
    
    if [ -f "$frontend_pid_file" ]; then
        local frontend_pid=$(cat "$frontend_pid_file")
        if kill -0 "$frontend_pid" 2>/dev/null; then
            log_success "前端应用正在运行 (PID: $frontend_pid)"
            
            # 检查端口
            if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then
                log_success "前端应用端口3000正常监听"
            else
                log_warning "前端应用端口3000未监听"
            fi
        else
            log_warning "前端应用进程不存在 (PID: $frontend_pid)"
            rm -f "$frontend_pid_file"
        fi
    else
        log_info "前端应用未运行"
    fi
}

# 检查端口占用
check_port_status() {
    log_section "端口占用状态"
    
    local ports=(
        "3000:GUI应用"
        "8001:Rust后端"
        "8002:Java后端"
        "8003:Python智能体"
        "8004:Java智能体"
        "8005:编排服务"
        "5432:PostgreSQL"
        "6379:Redis"
    )
    
    for port_info in "${ports[@]}"; do
        local port="${port_info%:*}"
        local service="${port_info#*:}"
        
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            local process=$(lsof -Pi :$port -sTCP:LISTEN | grep LISTEN | head -1 | awk '{print $1}')
            log_success "端口 $port ($service) - 被 $process 占用"
        else
            log_info "端口 $port ($service) - 可用"
        fi
    done
}

# 检查服务健康状态
check_service_health() {
    log_section "服务健康状态"
    
    for service in "${CORE_SERVICES[@]}"; do
        if [[ "$service" =~ ^(postgres|redis)$ ]]; then
            continue  # 跳过数据库服务
        fi
        
        local port=$(get_service_port "$service")
        local name=$(get_service_name "$service")
        local health_endpoint=$(get_health_endpoint "$service")
        
        if [ -n "$health_endpoint" ]; then
            local url="http://localhost:$port$health_endpoint"
            if curl -s "$url" > /dev/null 2>&1; then
                log_success "$name (端口$port) - 健康"
            else
                log_error "$name (端口$port) - 不健康"
            fi
        fi
    done
    
    # 检查GUI应用
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        log_success "GUI应用 (端口3000) - 健康"
    else
        log_error "GUI应用 (端口3000) - 不健康"
    fi
}

# 显示系统信息
show_system_info() {
    log_section "系统信息"
    
    log_info "项目根目录: $PROJECT_ROOT"
    log_info "脚本目录: $SCRIPT_DIR"
    log_info "日志目录: $LOGS_DIR"
    log_info "当前时间: $(date)"
    log_info "系统: $(uname -s) $(uname -r)"
    
    if command -v docker &> /dev/null; then
        log_info "Docker版本: $(docker --version)"
    fi
    
    if command -v docker-compose &> /dev/null; then
        log_info "Docker Compose版本: $(docker-compose --version)"
    fi
}

# 主函数
main() {
    # 显示系统信息
    show_system_info
    
    # 检查各项状态
    check_docker_status
    check_frontend_status
    check_port_status
    check_service_health
    
    # 显示总结
    show_final_status
}

# 显示最终状态
show_final_status() {
    echo ""
    log_success "状态检查完成！"
    log_info "如需启动服务，请运行: ./scripts/dev/start-complete.sh"
    log_info "如需停止服务，请运行: ./scripts/dev/stop-complete.sh"
    log_info "如需重启服务，请运行: ./scripts/dev/restart.sh"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
