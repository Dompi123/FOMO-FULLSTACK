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

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error "Failed to install Homebrew"
fi

# Install required tools
log "Installing required tools..."
TOOLS=(fswatch parallel swiftlint)
for tool in "${TOOLS[@]}"; do
    if ! command -v $tool &> /dev/null; then
        log "Installing $tool..."
        if ! brew install $tool; then
            error "Failed to install $tool"
        fi
    else
        log "✅ $tool is already installed"
    fi
done

# Create directory structure
log "Creating directory structure..."
mkdir -p automation/{logs,config,scripts}
chmod 755 automation
chmod 755 automation/scripts/agent_daemon.sh

# Set up Swift package for contract validation
log "Setting up Swift package dependencies..."
if [ ! -d "Scripts" ]; then
    mkdir -p Scripts
    (cd Scripts && swift package init --type library) || error "Failed to initialize Swift package"
fi

# Add contract validation dependency
(cd Scripts && swift package add swift-validate-contracts) || error "Failed to add contract validation package"

# Build Swift package
log "Building Swift packages..."
(cd Scripts && swift build -c release) || error "Failed to build Swift packages"

# Install SwiftLint configuration
log "Setting up SwiftLint..."
if [ ! -f ".swiftlint.yml" ]; then
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
fi

# Install LaunchAgent
log "Installing LaunchAgent..."
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
mkdir -p "$LAUNCH_AGENTS_DIR"

# Unload existing agent if present
if [ -f "$LAUNCH_AGENTS_DIR/com.fomo.cursor-agent.plist" ]; then
    log "Unloading existing agent..."
    launchctl unload "$LAUNCH_AGENTS_DIR/com.fomo.cursor-agent.plist" 2>/dev/null || true
fi

# Copy and load new agent
cp automation/com.fomo.cursor-agent.plist "$LAUNCH_AGENTS_DIR/" || error "Failed to copy LaunchAgent plist"
chmod 644 "$LAUNCH_AGENTS_DIR/com.fomo.cursor-agent.plist"

log "Loading agent..."
launchctl load "$LAUNCH_AGENTS_DIR/com.fomo.cursor-agent.plist" || error "Failed to load LaunchAgent"

# Verify agent is running
sleep 2
if launchctl list | grep -q "com.fomo.cursor-agent"; then
    log "✅ Cursor agent is running"
else
    error "Failed to start cursor agent"
fi

# Set up log monitoring with color output
log "Setting up log monitoring..."
tail -f automation/logs/agent.log | awk '
    /✅/ {print "\033[32m" $0 "\033[0m"; next}
    /❌/ {print "\033[31m" $0 "\033[0m"; next}
    /⚠️/ {print "\033[33m" $0 "\033[0m"; next}
    {print}
' &

log "✅ Installation complete!"
log "Monitor the logs with: tail -f automation/logs/agent.log"
log "View agent status with: launchctl list | grep com.fomo.cursor-agent" 