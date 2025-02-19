#!/bin/bash

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔒 Starting Secure Integration Flow${NC}"

# Configuration
CURSOR_TOOLS_DIR=".cursor-tools"
SECURITY_REPORT="integration-audit.html"
DOCKER_IMAGE="node:18-slim"
INTEGRATION_LINK="core-integration"
TARGET_PATH="FOMO_FINAL/FOMO_FINAL"

# Pre-validation hook
pre_validation() {
    echo -e "${GREEN}🔍 Running Pre-validation${NC}"
    if ! ./scripts/validate_all.sh; then
        echo -e "${RED}❌ Pre-validation failed${NC}"
        exit 1
    fi
    
    if [ -d "$CURSOR_TOOLS_DIR" ]; then
        echo -e "${RED}❌ Isolation violation - $CURSOR_TOOLS_DIR already exists${NC}"
        exit 1
    fi
}

# Secure clone with protection and verification
secure_clone() {
    echo -e "${BLUE}📦 Setting up protected environment${NC}"
    if ! git clone https://github.com/eastlondoner/cursor-tools "$CURSOR_TOOLS_DIR" \
        --config core.protectPath=true \
        --depth 1; then
        echo -e "${RED}❌ Failed to clone cursor-tools securely${NC}"
        exit 1
    fi
    
    # Verify clone success
    if [ -d "$CURSOR_TOOLS_DIR" ]; then
        echo -e "${GREEN}✅ Clone verification successful${NC}"
    else
        echo -e "${RED}❌ Clone verification failed${NC}"
        exit 1
    fi
}

# Isolated dependency installation
isolated_deps() {
    echo -e "${BLUE}🔐 Installing dependencies in isolation${NC}"
    if ! docker run --rm -v "$(pwd)/$CURSOR_TOOLS_DIR:/tools" \
        "$DOCKER_IMAGE" sh -c 'cd /tools && npm ci --production'; then
        echo -e "${RED}❌ Isolated dependency installation failed${NC}"
        exit 1
    fi
}

# Safe symlink creation
create_symlink() {
    echo -e "${BLUE}🔗 Creating secure integration link${NC}"
    local target="$(pwd)/$TARGET_PATH"
    local link="$CURSOR_TOOLS_DIR/$INTEGRATION_LINK"
    
    if [ ! -d "$target" ]; then
        echo -e "${RED}❌ Target directory not found: $target${NC}"
        exit 1
    fi
    
    if ! ln -sfn "$target" "$link"; then
        echo -e "${RED}❌ Failed to create secure symlink${NC}"
        exit 1
    fi
    
    # Verify symlink
    if [ -L "$link" ] && [ -e "$link" ]; then
        echo -e "${GREEN}✅ Symlink verification successful${NC}"
    else
        echo -e "${RED}❌ Symlink verification failed${NC}"
        exit 1
    fi
}

# Security audit
security_audit() {
    echo -e "${PURPLE}🔐 Running security audit${NC}"
    if ! "$CURSOR_TOOLS_DIR/bin/cursor-tools" audit \
        --config .cursorrules \
        --report "$SECURITY_REPORT"; then
        echo -e "${RED}❌ Security audit failed${NC}"
        exit 1
    fi
    
    # Verify audit report
    if [ -f "$SECURITY_REPORT" ]; then
        echo -e "${GREEN}✅ Security audit report generated${NC}"
        open "$SECURITY_REPORT"
    else
        echo -e "${RED}❌ Security audit report not found${NC}"
        exit 1
    fi
}

# Test integration
test_integration() {
    echo -e "${PURPLE}🧪 Testing integration${NC}"
    if ! "$CURSOR_TOOLS_DIR/bin/cursor-tools" test-integration \
        --path "$TARGET_PATH" \
        --config .cursorrules; then
        echo -e "${RED}❌ Integration tests failed${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Integration tests passed${NC}"
}

# Post-validation hook
post_validation() {
    echo -e "${GREEN}✨ Running post-validation${NC}"
    if ! ./scripts/nuclear_reset.sh; then
        echo -e "${RED}❌ Nuclear reset failed${NC}"
        exit 1
    fi
    
    if ! xcodegen generate; then
        echo -e "${RED}❌ XcodeGen failed${NC}"
        exit 1
    fi
    
    if ! ./scripts/validate_fomofinal.sh; then
        echo -e "${RED}❌ Final validation failed${NC}"
        exit 1
    fi
}

# Cleanup
cleanup() {
    echo -e "${BLUE}🧹 Cleaning up${NC}"
    if [ "$1" == "success" ]; then
        echo -e "${GREEN}✅ Integration successful - preserving $CURSOR_TOOLS_DIR${NC}"
        # Verify final state
        [ -d "$CURSOR_TOOLS_DIR" ] && \
            echo -e "${GREEN}✅ Integration environment preserved${NC}" || \
            echo -e "${RED}⚠️ Integration environment not found${NC}"
    else
        rm -rf "$CURSOR_TOOLS_DIR" "$SECURITY_REPORT"
        echo -e "${BLUE}🗑 Cleaned up temporary files${NC}"
        # Verify cleanup
        [ ! -d "$CURSOR_TOOLS_DIR" ] && [ ! -f "$SECURITY_REPORT" ] && \
            echo -e "${GREEN}✅ Cleanup successful${NC}" || \
            echo -e "${RED}⚠️ Cleanup incomplete${NC}"
    fi
}

main() {
    # Trap for cleanup on script exit
    trap 'cleanup failure' EXIT
    
    pre_validation
    secure_clone
    isolated_deps
    create_symlink
    security_audit
    test_integration
    post_validation
    
    # If we get here, everything succeeded
    trap - EXIT
    cleanup success
    echo -e "${GREEN}✅ Secure integration flow completed successfully${NC}"
}

main 