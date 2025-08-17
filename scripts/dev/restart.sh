#!/bin/bash

# Agentic System - Restart Services Script
# Refactored version: Using common function library and configuration

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Import common function library and configuration
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../config/services.conf"

# Script Information
SCRIPT_NAME="restart.sh"
SCRIPT_VERSION="2.0.0"
SCRIPT_DESCRIPTION="Restart Agentic System Services"

# Display Script Information
log_section "Agentic System - Restart Services Script"
log_info "Version: $SCRIPT_VERSION"
log_info "Description: $SCRIPT_DESCRIPTION"

# Main Function
main() {
    log_step "Restarting Agentic System Services"
    
    # Stop services
    log_info "Stopping existing services..."
    "$SCRIPT_DIR/stop-complete.sh"
    
    # Wait a moment
    sleep 5
    
    # Start services
    log_info "Restarting services..."
    "$SCRIPT_DIR/start-complete.sh"
    
    log_success "Services restarted successfully!"
}

# Script Entry Point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
