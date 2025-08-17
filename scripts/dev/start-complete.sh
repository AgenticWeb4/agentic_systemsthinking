#!/bin/bash

# Agentic System - Complete Startup Script (Including Frontend)
# Refactored version: Using common function library and configuration

set -euo pipefail

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 导入通用函数库和配置
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../config/services.conf"

# Script Information
SCRIPT_NAME="start-complete.sh"
SCRIPT_VERSION="2.0.0"
SCRIPT_DESCRIPTION="Start Agentic System Complete Environment (Including Frontend)"

# Display Script Information
log_section "Agentic System - Complete Startup Script"
log_info "Version: $SCRIPT_VERSION"
log_info "Description: $SCRIPT_DESCRIPTION"

# Main Function
main() {
    # Environment check
    check_docker
    check_all_ports
    create_directories
    
    # Start core services
    log_step "Starting Core Services"
    docker-compose up -d --build "${CORE_SERVICES[@]}"
    
    if [ $? -eq 0 ]; then
        log_success "Core services started successfully!"
    else
        log_error "Core services failed to start"
        exit 1
    fi
    
    # Wait for services to start
    log_info "Waiting for services to start..."
    sleep 15
    
    # Start frontend application
    start_frontend_application
    
    # Display results
    show_final_status
}

# Start Frontend Application
start_frontend_application() {
    log_step "Starting Frontend Application"
    
    local frontend_dir="$PROJECT_ROOT/src/client/desktop"
    local frontend_log="$LOGS_DIR/frontend.log"
    local frontend_pid_file="$LOGS_DIR/frontend.pid"
    
    # Switch to frontend directory
    cd "$frontend_dir"
    
    # Check if dependencies are installed
    if [ ! -d "node_modules" ]; then
        log_info "Installing frontend dependencies..."
        npm install
    fi
    
    # Start frontend application (background)
    log_info "Starting Svelte application..."
    npm run dev -- --host 0.0.0.0 --port 3000 > "$frontend_log" 2>&1 &
    local frontend_pid=$!
    
    # Wait for frontend application to start
    log_info "Waiting for frontend application to start..."
    sleep 10
    
    # Check frontend application status
    if curl -s http://localhost:3000 > /dev/null; then
        log_success "Frontend application started successfully!"
        echo "$frontend_pid" > "$frontend_pid_file"
        log_info "Frontend process ID: $frontend_pid"
    else
        log_error "Frontend application failed to start"
        log_info "Please check logs: tail -f $frontend_log"
    fi
    
    # Return to project root directory
    cd "$PROJECT_ROOT"
}

# Display Final Status
show_final_status() {
    echo ""
    log_success "Agentic System Complete Environment Started Successfully!"
    echo ""
    show_service_urls
    echo ""
    show_frontend_guide
    echo ""
    show_available_commands
    echo ""
    log_info "Start using Agentic System now!"
}

# Script Entry Point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
