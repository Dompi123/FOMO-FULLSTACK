#!/bin/bash

# Configuration
WORKSPACE_DIR="/Users/dom.khr/Desktop/fomofinal copy"
LOG_DIR="$WORKSPACE_DIR/automation/logs"

# Ensure log directory exists and is writable
mkdir -p "$LOG_DIR"
chmod 755 "$LOG_DIR"

# Function to log messages with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/agent.log"
}

# Log startup
log "🚀 Agent starting..."
log "📁 Workspace: $WORKSPACE_DIR"
log "📝 Log directory: $LOG_DIR"

# Function to install fswatch
install_fswatch() {
    log "📦 Installing fswatch..."
    if ! command -v brew &> /dev/null; then
        log "🍺 Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            log "❌ Failed to install Homebrew"
            exit 1
        }
    fi
    
    brew install fswatch || {
        log "❌ Failed to install fswatch"
        exit 1
    }
    log "✅ fswatch installed successfully"
}

# Function to monitor file changes
monitor_changes() {
    log "👀 Starting file monitoring..."
    
    # Use fswatch to monitor Swift files
    fswatch -0 -r \
        --event Created \
        --event Updated \
        --event Removed \
        --event Renamed \
        --exclude '\.git' \
        --include '\.swift$' \
        "$WORKSPACE_DIR/FOMO_FINAL" \
        | while read -d "" event; do
            log "🔄 Change detected: $event"
        done
}

# Main function
main() {
    cd "$WORKSPACE_DIR" || {
        log "❌ Error: Could not change to workspace directory"
        exit 1
    }
    
    # Verify fswatch is installed
    if ! command -v fswatch &> /dev/null; then
        install_fswatch
    else
        log "✅ fswatch is already installed"
    fi
    
    # Start monitoring
    monitor_changes
}

# Start the agent
main 