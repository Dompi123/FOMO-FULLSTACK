#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Starting FOMO Agent Installation...${NC}"

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run with sudo${NC}"
    exit 1
fi

# Get the real user who ran sudo
REAL_USER=$(who am i | awk '{print $1}')
REAL_HOME=$(eval echo ~$REAL_USER)

# Project directory
PROJECT_DIR="/Users/$REAL_USER/Desktop/fomofinal copy"
AGENT_NAME="com.fomo.cursor-agent"

echo "Installing for user: $REAL_USER"
echo "Project directory: $PROJECT_DIR"

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    sudo -u $REAL_USER /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install fswatch
echo "Installing fswatch..."
sudo -u $REAL_USER brew install fswatch

# Create necessary directories
echo "Creating directories..."
mkdir -p "$PROJECT_DIR/automation/logs"
mkdir -p "$REAL_HOME/Library/LaunchAgents"
chown -R $REAL_USER "$PROJECT_DIR/automation"

# Set permissions
echo "Setting permissions..."
chmod +x "$PROJECT_DIR/automation/scripts/agent_daemon.sh"
chown $REAL_USER "$PROJECT_DIR/automation/scripts/agent_daemon.sh"

# Stop existing agent
echo "Stopping existing agent..."
sudo -u $REAL_USER launchctl bootout gui/$(id -u $REAL_USER)/$AGENT_NAME 2>/dev/null || true

# Copy plist file
echo "Installing LaunchAgent..."
cp "$PROJECT_DIR/automation/com.fomo.cursor-agent.plist" "$REAL_HOME/Library/LaunchAgents/"
chown $REAL_USER "$REAL_HOME/Library/LaunchAgents/com.fomo.cursor-agent.plist"
chmod 644 "$REAL_HOME/Library/LaunchAgents/com.fomo.cursor-agent.plist"

# Load new agent
echo "Starting agent..."
sudo -u $REAL_USER launchctl bootstrap gui/$(id -u $REAL_USER) "$REAL_HOME/Library/LaunchAgents/com.fomo.cursor-agent.plist"

# Verify agent is running
sleep 2
if sudo -u $REAL_USER launchctl list | grep -q "$AGENT_NAME"; then
    echo -e "${GREEN}✅ Agent successfully installed and running!${NC}"
    echo "You can monitor the logs with:"
    echo "tail -f $PROJECT_DIR/automation/logs/agent.log"
else
    echo -e "${RED}❌ Failed to start agent${NC}"
    exit 1
fi 