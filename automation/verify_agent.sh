#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Running Agent Verification Tests...${NC}"

# Test 1: Create a new file
echo -e "${BLUE}Test 1: Creating new file...${NC}"
cat << EOF > FOMO_FINAL/Features/Venues/Views/TestView1.swift
import SwiftUI

struct TestView1: View {
    var body: some View {
        Text("Test View 1")
    }
}
EOF
sleep 2

# Test 2: Modify existing file
echo -e "${BLUE}Test 2: Modifying file...${NC}"
echo "// Modified at $(date)" >> FOMO_FINAL/Features/Venues/Views/TestView1.swift
sleep 2

# Test 3: Create another file
echo -e "${BLUE}Test 3: Creating another file...${NC}"
cat << EOF > FOMO_FINAL/Features/Venues/Views/TestView2.swift
import SwiftUI

struct TestView2: View {
    var body: some View {
        Text("Test View 2")
    }
}
EOF
sleep 2

# Test 4: Delete a file
echo -e "${BLUE}Test 4: Deleting file...${NC}"
rm FOMO_FINAL/Features/Venues/Views/TestView2.swift
sleep 2

# Check logs
echo -e "${BLUE}Checking agent logs...${NC}"
echo "Agent Log Contents:"
cat automation/logs/agent.log

echo -e "${GREEN}Verification complete! Check the log entries above to confirm all changes were detected.${NC}"
echo "Expected to see:"
echo "1. File creation (TestView1.swift)"
echo "2. File modification (TestView1.swift)"
echo "3. Another file creation (TestView2.swift)"
echo "4. File deletion (TestView2.swift)" 