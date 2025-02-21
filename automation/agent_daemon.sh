#!/bin/bash
set -eo pipefail

# Configuration
WORKSPACE_DIR="$PWD"
LOG_DIR="$WORKSPACE_DIR/automation/logs"
CONFIG_DIR="$WORKSPACE_DIR/automation/config"
SCRIPTS_DIR="$WORKSPACE_DIR/automation/scripts"

# Create required directories
mkdir -p "$LOG_DIR" "$CONFIG_DIR" "$SCRIPTS_DIR"

# Initialize logging
exec 1> >(tee -a "$LOG_DIR/agent.log")
exec 2> >(tee -a "$LOG_DIR/agent.error.log")

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Vault configuration
if [ -n "$VAULT_TOKEN" ]; then
    log "✅ Vault token detected"
    vault login "$VAULT_TOKEN" > /dev/null 2>&1
else
    log "❌ No Vault token provided"
    exit 1
fi

# Health check function
health_check() {
    # Check Swift package manager
    if ! command -v swift &> /dev/null; then
        log "❌ Swift not found"
        return 1
    fi
    
    # Check contract validator
    if [ ! -f "./Scripts/.build/release/swift-validate-contracts" ]; then
        log "❌ Contract validator not found"
        return 1
    }
    
    # Check required directories
    for dir in "FOMO_FINAL" "FOMO_FINAL/Features" "FOMO_FINAL/Core"; do
        if [ ! -d "$dir" ]; then
            log "❌ Required directory $dir not found"
            return 1
        fi
    done
    
    return 0
}

# Contract validation function
validate_contracts() {
    log "🔍 Running contract validation"
    ./Scripts/.build/release/swift-validate-contracts \
        --contracts-dir ./FOMO_FINAL/Core/Network/Contracts \
        --output "$LOG_DIR/contracts.log"
}

# File system monitoring
monitor_changes() {
    log "👀 Starting file system monitoring"
    fswatch -0 \
        ./FOMO_FINAL/Features \
        ./FOMO_FINAL/Core \
        ./FOMO_FINAL/App \
        | while read -d "" event; do
        log "⚡ Change detected: $event"
        validate_contracts
    done
}

# Main loop
main() {
    log "🚀 Starting autonomous agent"
    
    # Initial health check
    if ! health_check; then
        log "❌ Health check failed"
        exit 1
    fi
    log "✅ Health check passed"
    
    # Initial contract validation
    validate_contracts
    
    # Start file system monitoring
    monitor_changes &
    
    # Keep the script running
    while true; do
        sleep 60
        if ! health_check; then
            log "⚠️ Health check failed, attempting recovery"
            # Add recovery logic here
        fi
    done
}

# Cleanup function
cleanup() {
    log "🛑 Stopping autonomous agent"
    pkill -f fswatch || true
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Start the agent
main 