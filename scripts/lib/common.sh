#!/bin/bash

# 系统思维智能体项目 - 通用函数库
# 提供所有脚本共用的函数和配置

set -euo pipefail

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# 获取项目根目录的绝对路径
get_project_root() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "$(cd "$script_dir/../.." && pwd)"
}

# 项目根目录
readonly PROJECT_ROOT="$(get_project_root)"
readonly LOGS_DIR="$PROJECT_ROOT/logs"
readonly SCRIPTS_DIR="$PROJECT_ROOT/scripts"

# 日志函数
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo -e "${CYAN}🔧 $1${NC}"
}

log_section() {
    echo -e "${PURPLE}📋 $1${NC}"
}

# 错误处理
handle_error() {
    local exit_code=$?
    local line_number=$1
    log_error "脚本在第 $line_number 行发生错误 (退出码: $exit_code)"
    exit $exit_code
}

# 设置错误处理
trap 'handle_error $LINENO' ERR

# 检查Docker状态
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker未安装，请先安装Docker"
        exit 1
    fi
    
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker守护进程未运行"
        log_info "请执行以下操作之一："
        log_info "1. 启动Docker Desktop应用程序"
        log_info "2. 或者在终端运行: sudo systemctl start docker (Linux)"
        log_info "3. 或者在终端运行: open -a Docker (macOS)"
        log_info ""
        log_info "等待Docker启动完成后，再次运行此脚本"
        exit 1
    fi
    
    log_success "Docker运行正常"
    log_info "Docker版本: $(docker --version)"
    log_info "Docker Compose版本: $(docker-compose --version)"
}

# 检查端口占用
check_port() {
    local port=$1
    local service=$2
    
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        log_warning "端口 $port 已被占用 ($service)"
        return 1
    else
        log_success "端口 $port 可用"
        return 0
    fi
}

# Check All Required Ports
check_all_ports() {
    local ports=(
        "3000:Svelte Frontend"
        "8001:Rust Backend"
        "8002:Java Backend"
        "8003:Python Agent"
        "8004:Java Agent"
        "8005:Java Orchestrator"
        "5432:PostgreSQL"
        "6379:Redis"
    )
    
    log_section "Checking Port Usage"
    local has_conflicts=false
    
    for port_info in "${ports[@]}"; do
        local port="${port_info%:*}"
        local service="${port_info#*:}"
        if ! check_port "$port" "$service"; then
            has_conflicts=true
        fi
    done
    
    if [ "$has_conflicts" = true ]; then
        log_warning "Port conflicts detected, please resolve and retry"
        return 1
    fi
    
    log_success "All port checks passed"
    return 0
}

# 创建必要目录
create_directories() {
    log_step "创建必要目录"
    mkdir -p "$LOGS_DIR"
    log_success "目录创建完成"
}

# 等待服务启动
wait_for_service() {
    local service_name=$1
    local url=$2
    local max_attempts=${3:-30}
    local delay=${4:-2}
    
    log_info "等待 $service_name 启动..."
    
    for ((i=1; i<=max_attempts; i++)); do
        if curl -s "$url" > /dev/null 2>&1; then
            log_success "$service_name 启动成功"
            return 0
        fi
        
        if [ $i -lt $max_attempts ]; then
            log_info "尝试 $i/$max_attempts，等待 ${delay}s..."
            sleep $delay
        fi
    done
    
    log_error "$service_name 启动超时"
    return 1
}

# 显示服务状态
show_service_status() {
    log_section "服务状态"
    docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
}

# 配置获取函数 (兼容Bash 3.2)
get_service_port() {
    local service=$1
    local var_name="SERVICE_PORTS_${service//-/_}"
    echo "${!var_name}"
}

get_service_name() {
    local service=$1
    local var_name="SERVICE_NAMES_${service//-/_}"
    echo "${!var_name}"
}

get_health_endpoint() {
    local service=$1
    local var_name="HEALTH_ENDPOINTS_${service//-/_}"
    echo "${!var_name}"
}

get_db_health_endpoint() {
    local service=$1
    local var_name="DB_HEALTH_ENDPOINTS_${service//-/_}"
    echo "${!var_name}"
}

# Display Service URLs
show_service_urls() {
    log_section "Service URLs"
    echo "   Svelte Frontend: http://localhost:3000"
    echo "   Rust Backend: http://localhost:8001"
    echo "   Java Backend: http://localhost:8002"
    echo "   Python Agent: http://localhost:8003"
    echo "   Java Agent: http://localhost:8004"
    echo "   Java Orchestrator: http://localhost:8005"
    echo "   PostgreSQL: localhost:5432"
    echo "   Redis: localhost:6379"
}

# Display Frontend Access Guide
show_frontend_guide() {
    log_section "🌐 Frontend Interface Access Guide"
    echo "   📱 Local Access:"
    echo "      Open browser and visit: http://localhost:3000"
    echo ""
    echo "   🌍 Network Access:"
    echo "      Other devices on same network: http://[YourIP]:3000"
    echo "      Get local IP: ifconfig | grep 'inet ' | grep -v 127.0.0.1"
    echo ""
    echo "   📱 Mobile Testing:"
    echo "      Phone/tablet connect to same WiFi, visit above address"
    echo ""
    echo "   🔧 Development Mode:"
    echo "      Frontend supports hot reload, auto-refresh after code changes"
}

# Display Available Commands
show_available_commands() {
    log_section "🔧 Common Operations"
    echo "   📊 View service status: ./scripts/dev/status.sh"
    echo "   🧪 Health check test: ./scripts/dev/test-services.sh"
    echo "   🔍 Endpoint test: ./scripts/dev/test-endpoints.sh"
    echo "   📋 View logs: make logs"
    echo "   🛑 Stop services: ./scripts/dev/stop-complete.sh"
    echo "   🔄 Restart services: ./scripts/dev/restart.sh"
    echo "   🧹 Clean up resources: ./scripts/dev/cleanup.sh"
    echo "   🎯 Stop frontend: kill \$(cat logs/frontend.pid)"
}

# 验证脚本参数
validate_script_args() {
    local script_name="$1"
    local expected_args="$2"
    local actual_args="$3"
    
    if [ "$actual_args" -ne "$expected_args" ]; then
        log_error "用法错误: $script_name 需要 $expected_args 个参数，但提供了 $actual_args 个"
        exit 1
    fi
}

# 检查文件是否存在
check_file_exists() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        log_success "$description: $file"
        return 0
    else
        log_error "$description: $file (缺失)"
        return 1
    fi
}

# 检查目录是否存在
check_directory_exists() {
    local dir="$1"
    local description="$2"
    
    if [ -d "$dir" ]; then
        log_success "$description: $dir"
        return 0
    else
        log_error "$description: $dir (缺失)"
        return 1
    fi
}
