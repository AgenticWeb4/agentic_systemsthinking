#!/bin/bash

# Agentic System - Complete Stop Script
# Refactored version: Using common function library and configuration

set -euo pipefail

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 导入通用函数库和配置
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../config/services.conf"

# Script Information
SCRIPT_NAME="stop-complete.sh"
SCRIPT_VERSION="2.0.0"
SCRIPT_DESCRIPTION="Stop Agentic System Complete Environment"

# Display Script Information
log_section "Agentic System - Complete Stop Script"
log_info "Version: $SCRIPT_VERSION"
log_info "Description: $SCRIPT_DESCRIPTION"

# Main Function
main() {
    # Stop frontend application
    stop_frontend_application
    
    # Stop Docker services
    stop_docker_services
    
    # Display results
    show_final_status
}

# Stop Frontend Application
stop_frontend_application() {
    local frontend_pid_file="$LOGS_DIR/frontend.pid"
    
    if [ -f "$frontend_pid_file" ]; then
        log_step "Stopping Frontend Application"
        local frontend_pid=$(cat "$frontend_pid_file")
        
        if kill -0 "$frontend_pid" 2>/dev/null; then
            kill "$frontend_pid"
            log_success "Frontend application stopped"
        else
            log_warning "Frontend application process not found"
        fi
        
        rm -f "$frontend_pid_file"
    else
        log_warning "Frontend process ID file not found"
    fi
}

# Stop Docker Services
stop_docker_services() {
    log_step "Stopping Docker Services"
    docker-compose down
    
    if [ $? -eq 0 ]; then
        log_success "Docker services stopped"
    else
        log_error "Failed to stop Docker services"
    fi
}

# Display Final Status
show_final_status() {
    echo ""
    log_success "Agentic System Complete Environment Stopped!"
    echo ""
    log_info "To start again, use: ./scripts/dev/start-complete.sh"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
