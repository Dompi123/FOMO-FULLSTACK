#!/bin/bash

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔒 Starting Secure Validation Flow${NC}"

# Configuration
CURSOR_TOOLS_DIR=".cursor-tools"
SECURITY_REPORT="security-audit.html"
DOCKER_IMAGE="node:18-slim"

# Pre-validation hook
pre_validation() {
    echo -e "${GREEN}🔍 Running Pre-validation${NC}"
    if ! ./scripts/validate_all.sh; then
        echo -e "${RED}❌ Pre-validation failed${NC}"
        exit 1
    fi
    
    if [ -d "$CURSOR_TOOLS_DIR" ]; then
        echo -e "${RED}❌ $CURSOR_TOOLS_DIR already exists${NC}"
        exit 1
    fi
}

# Isolated clone
isolated_clone() {
    echo -e "${BLUE}📦 Setting up isolated environment${NC}"
    if ! git clone https://github.com/eastlondoner/cursor-tools.git "$CURSOR_TOOLS_DIR" --branch stable --depth 1; then
        echo -e "${RED}❌ Failed to clone cursor-tools${NC}"
        exit 1
    fi
}

# Dockerized setup
dockerized_setup() {
    echo -e "${BLUE}🐳 Setting up Docker environment${NC}"
    docker run -v "$(pwd)/$CURSOR_TOOLS_DIR:/tools" -v "$(pwd)/FOMO_FINAL:/fomo" \
        "$DOCKER_IMAGE" sh -c '
            cd /tools &&
            npm install --production &&
            ./bin/cursor-tools configure --path /fomo
        '
}

# Security audit
security_audit() {
    echo -e "${PURPLE}🔐 Running security audit${NC}"
    "$CURSOR_TOOLS_DIR/bin/cursor-tools" audit \
        --config .cursorrules \
        --report "$SECURITY_REPORT"
}

# Post-validation hook
post_validation() {
    echo -e "${GREEN}✨ Running post-validation${NC}"
    ./scripts/nuclear_reset.sh &&
        xcodegen generate &&
        ./scripts/final_validation.sh
    
    if [ -f "$SECURITY_REPORT" ]; then
        open "$SECURITY_REPORT"
    fi
}

# Cleanup
cleanup() {
    echo -e "${BLUE}🧹 Cleaning up${NC}"
    if [ "$1" == "success" ]; then
        echo -e "${GREEN}✅ Validation successful - preserving $CURSOR_TOOLS_DIR${NC}"
    else
        rm -rf "$CURSOR_TOOLS_DIR" "$SECURITY_REPORT"
        echo -e "${BLUE}🗑 Cleaned up temporary files${NC}"
    fi
}

main() {
    # Trap for cleanup on script exit
    trap 'cleanup failure' EXIT
    
    pre_validation
    isolated_clone
    dockerized_setup
    security_audit
    post_validation
    
    # If we get here, everything succeeded
    trap - EXIT
    cleanup success
    echo -e "${GREEN}✅ Secure validation flow completed successfully${NC}"
}

main 