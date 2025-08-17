#!/bin/bash

# Docker状态检查脚本
# 重构版本：使用通用函数库和配置

set -euo pipefail

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 导入通用函数库和配置
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../config/services.conf"

# 脚本信息
SCRIPT_NAME="check-docker.sh"
SCRIPT_VERSION="2.0.0"
SCRIPT_DESCRIPTION="检查Docker状态和端口占用"

# 显示脚本信息
log_section "Docker状态检查脚本"
log_info "版本: $SCRIPT_VERSION"
log_info "描述: $SCRIPT_DESCRIPTION"

# 主函数
main() {
    # 检查Docker状态
    check_docker
    
    # 检查端口占用
    check_all_ports
    
    # 显示结果
    show_final_status
}

# 显示最终状态
show_final_status() {
    echo ""
    log_success "Docker环境检查完成！"
    log_info "现在可以运行: make dev 或 ./scripts/dev/start-complete.sh"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
