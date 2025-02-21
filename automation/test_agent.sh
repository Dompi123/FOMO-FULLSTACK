#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Function to log messages
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

# Function to show progress
show_step() {
    echo -e "${BLUE}Step: $1${NC}"
    sleep 2  # Give the agent time to detect changes
}

# Function to check agent status
check_agent() {
    if ! launchctl list | grep -q "com.fomo.cursor-agent"; then
        log "Agent not running. Restarting..."
        launchctl unload ~/Library/LaunchAgents/com.fomo.cursor-agent.plist 2>/dev/null || true
        launchctl load ~/Library/LaunchAgents/com.fomo.cursor-agent.plist
        sleep 2
    else
        log "Agent is running"
    fi
}

# Function to verify logs
check_logs() {
    if [ ! -s automation/logs/agent.log ]; then
        echo -e "${RED}Warning: No log entries found${NC}"
        return 1
    else
        log "Log file contains entries"
        return 0
    fi
}

# Main test sequence
main() {
    log "Starting enhanced FOMO Agent Test..."
    
    # Step 1: Setup and Permissions
    show_step "Setting up permissions..."
    chmod +x automation/scripts/agent_daemon.sh
    mkdir -p automation/logs
    chmod 755 automation/logs
    touch automation/logs/agent.log
    chmod 644 automation/logs/agent.log
    
    # Step 2: Check and restart agent
    show_step "Checking agent status..."
    check_agent
    
    # Step 3: Clean up previous test files
    show_step "Cleaning up previous test files..."
    rm -f FOMO_FINAL/Features/Venues/Views/TestAgent*.swift
    rm -f FOMO_FINAL/Features/Venues/Views/AgentTestView.swift
    > automation/logs/agent.log
    
    # Step 4: Create test file
    show_step "Creating test file..."
    cat << EOF > FOMO_FINAL/Features/Venues/Views/AgentTestView.swift
import SwiftUI

struct AgentTestView: View {
    var body: some View {
        Text("Testing Agent Monitoring")
            .fomoTextStyle(FOMOTheme.Typography.titleLarge)
            .foregroundColor(FOMOTheme.Colors.primary)
    }
}

#if DEBUG
struct AgentTestView_Previews: PreviewProvider {
    static var previews: some View {
        AgentTestView()
    }
}
#endif
EOF
    
    # Step 5: Create additional test file
    show_step "Creating additional test file..."
    cat << EOF > FOMO_FINAL/Features/Venues/Views/TestAgent2.swift
import SwiftUI

struct TestAgent2: View {
    var body: some View {
        Text("Additional Test View")
    }
}
EOF
    
    # Step 6: Modify test file
    show_step "Modifying test file..."
    echo "// Modified at $(date)" >> FOMO_FINAL/Features/Venues/Views/TestAgent2.swift
    
    # Step 7: Create test directory
    show_step "Creating test directory..."
    mkdir -p FOMO_FINAL/Features/Venues/Tests
    
    # Step 8: Delete test file
    show_step "Deleting test file..."
    rm FOMO_FINAL/Features/Venues/Views/TestAgent2.swift
    
    # Step 9: Check logs
    show_step "Checking agent logs..."
    sleep 2  # Give agent time to write logs
    
    echo -e "${GREEN}Agent Log Contents:${NC}"
    cat automation/logs/agent.log
    
    # Step 10: Verify logs
    if check_logs; then
        log "✅ Test completed successfully!"
    else
        log "⚠️ Test completed but no log entries were found"
        log "Attempting to restart agent..."
        check_agent
    fi
    
    # Step 11: Start monitoring
    log "Starting live monitoring (press Ctrl+C to stop)..."
    echo -e "${BLUE}Try making some manual changes to see them appear below:${NC}"
    echo -e "${BLUE}1. Edit FOMO_FINAL/Features/Venues/Views/AgentTestView.swift${NC}"
    echo -e "${BLUE}2. Create new files in FOMO_FINAL/Features/Venues/Views/${NC}"
    echo -e "${BLUE}3. Delete test files${NC}"
    
    # Monitor logs
    tail -f automation/logs/agent.log
}

# Run main test sequence
main 