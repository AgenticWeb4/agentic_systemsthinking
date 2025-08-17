#!/bin/bash

# 系统思维智能体项目 - 清理资源脚本
# 重构版本：使用通用函数库和配置

set -euo pipefail

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 导入通用函数库和配置
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../config/services.conf"

# 脚本信息
SCRIPT_NAME="cleanup.sh"
SCRIPT_VERSION="2.0.0"
SCRIPT_DESCRIPTION="清理Agentic System资源"

# 显示脚本信息
log_section "Agentic System - 清理资源脚本"
log_info "版本: $SCRIPT_VERSION"
log_info "描述: $SCRIPT_DESCRIPTION"

# 清理函数
cleanup_docker() {
    log_step "清理Docker资源"
    
    # 停止所有容器
    log_info "停止所有Docker容器..."
    docker-compose down --remove-orphans
    
    # 清理未使用的镜像
    log_info "清理未使用的Docker镜像..."
    docker image prune -f
    
    # 清理未使用的网络
    log_info "清理未使用的Docker网络..."
    docker network prune -f
    
    # 清理未使用的卷
    log_info "清理未使用的Docker卷..."
    docker volume prune -f
    
    log_success "Docker资源清理完成"
}

cleanup_logs() {
    log_step "清理日志文件"
    
    if [ -d "$LOGS_DIR" ]; then
        log_info "清理日志目录..."
        rm -rf "$LOGS_DIR"/*
        log_success "日志文件清理完成"
    else
        log_info "日志目录不存在，无需清理"
    fi
}

cleanup_node_modules() {
    log_step "清理Node.js依赖"
    
    local gui_dir="$PROJECT_ROOT/src/client/desktop"
    if [ -d "$gui_dir/node_modules" ]; then
        log_info "清理GUI应用的node_modules..."
        rm -rf "$gui_dir/node_modules"
        log_success "Node.js依赖清理完成"
    else
        log_info "GUI应用的node_modules不存在，无需清理"
    fi
}

cleanup_build_artifacts() {
    log_step "清理构建产物"
    
    # 清理Java构建产物
    local java_dirs=(
        "src/ai/agents/java/target"
        "src/ai/agents/orchestration/target"
        "src/server/java/target"
    )
    
    for dir in "${java_dirs[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            log_info "清理 $dir..."
            rm -rf "$PROJECT_ROOT/$dir"
        fi
    done
    
    # 清理Rust构建产物
    local rust_dir="$PROJECT_ROOT/src/server/rust/target"
    if [ -d "$rust_dir" ]; then
        log_info "清理Rust构建产物..."
        rm -rf "$rust_dir"
    fi
    
    log_success "构建产物清理完成"
}

# 主函数
main() {
    log_warning "此操作将清理所有项目资源，包括："
    log_warning "- Docker容器、镜像、网络、卷"
    log_warning "- 日志文件"
    log_warning "- Node.js依赖"
    log_warning "- 构建产物"
    echo ""
    
    read -p "是否继续？(y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "操作已取消"
        exit 0
    fi
    
    # 执行清理
    cleanup_docker
    cleanup_logs
    cleanup_node_modules
    cleanup_build_artifacts
    
    log_success "所有资源清理完成！"
    log_info "如需重新启动项目，请运行: ./scripts/dev/start-complete.sh"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
