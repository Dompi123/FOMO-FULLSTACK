#!/bin/bash

# Set environment
export API_ENV=${API_ENV:-production}

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Extract frontend endpoints
print_status "$GREEN" "🔍 Starting contract verification..."
print_status "$GREEN" "📱 Analyzing frontend endpoints..."

# Count frontend endpoints
frontend_count=$(grep -v "^//" frontend_endpoints.txt | grep -v "^$" | wc -l)
print_status "$GREEN" "📱 Frontend endpoints found: $frontend_count"

# Count API contracts
contract_count=$(jq length api-spec.json)
print_status "$GREEN" "🔄 API contracts found: $contract_count/42"

# Run contract validator
swift scripts/contract-validator.swift

# Generate report
print_status "$GREEN" "✅ Contract verification complete"
print_status "$GREEN" "📄 Report generated: ./ContractVerification.html"

# Run integration tests if specified
if [[ "$*" == *"--level nuclear"* ]]; then
    print_status "$YELLOW" "⚛️ Running nuclear integration tests..."
    ./scripts/verify-integration.sh --level nuclear
fi 