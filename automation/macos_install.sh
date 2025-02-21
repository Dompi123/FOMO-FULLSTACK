#!/bin/bash
set -eo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

# Ensure we're in the right directory
WORKSPACE_DIR="$(pwd)"
if [[ ! "$WORKSPACE_DIR" =~ "fomofinal copy"$ ]]; then
    error "Please run this script from the project root directory"
fi

# Create directory structure
log "Creating directory structure..."
mkdir -p automation/{logs,config,scripts}

# Copy agent daemon script to scripts directory
log "Setting up agent daemon..."
cp automation/scripts/agent_daemon.sh automation/scripts/
chmod 755 automation/scripts/agent_daemon.sh

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error "Failed to install Homebrew"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Install required tools
log "Installing required tools..."
for tool in fswatch parallel swiftlint; do
    if ! command -v $tool &> /dev/null; then
        log "Installing $tool..."
        HOMEBREW_NO_AUTO_UPDATE=1 brew install $tool || error "Failed to install $tool"
    else
        log "✅ $tool is already installed"
    fi
done

# Set up Swift package
log "Setting up Swift package..."
if [ ! -d "Scripts" ]; then
    mkdir -p Scripts
    (cd Scripts && swift package init --type library) || error "Failed to initialize Swift package"
fi

# Configure SwiftLint
log "Configuring SwiftLint..."
cat > .swiftlint.yml << EOL
disabled_rules:
  - trailing_whitespace
  - line_length
opt_in_rules:
  - empty_count
  - missing_docs
included:
  - FOMO_FINAL
  - FOMO_PRODUCTION
excluded:
  - Scripts
  - .build
  - Pods
EOL

# Set up LaunchAgent
log "Setting up LaunchAgent..."
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
mkdir -p "$LAUNCH_AGENTS_DIR"

# Stop existing agent if running
if launchctl list | grep -q "com.fomo.cursor-agent"; then
    log "Stopping existing agent..."
    launchctl unload "$LAUNCH_AGENTS_DIR/com.fomo.cursor-agent.plist" 2>/dev/null || true
fi

# Install new agent
cp automation/com.fomo.cursor-agent.plist "$LAUNCH_AGENTS_DIR/"
chmod 644 "$LAUNCH_AGENTS_DIR/com.fomo.cursor-agent.plist"

# Start agent
log "Starting agent..."
launchctl load "$LAUNCH_AGENTS_DIR/com.fomo.cursor-agent.plist"

# Verify agent is running
sleep 2
if launchctl list | grep -q "com.fomo.cursor-agent"; then
    log "✅ Agent successfully started"
else
    error "Failed to start agent"
fi

# Set up log monitoring
log "Setting up log monitoring..."
mkdir -p "$WORKSPACE_DIR/automation/logs"
touch "$WORKSPACE_DIR/automation/logs/agent.log"

# Start log monitoring in background
(tail -f "$WORKSPACE_DIR/automation/logs/agent.log" | awk '
    /✅/ {print "\033[32m" $0 "\033[0m"; next}
    /❌/ {print "\033[31m" $0 "\033[0m"; next}
    /⚠️/ {print "\033[33m" $0 "\033[0m"; next}
    {print}
') &

log "✅ Installation complete!"
log "Monitor logs: tail -f $WORKSPACE_DIR/automation/logs/agent.log"
log "Check status: launchctl list | grep com.fomo.cursor-agent" 