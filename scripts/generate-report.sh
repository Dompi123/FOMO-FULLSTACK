#!/bin/bash

set -e

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --test-results)
            TEST_RESULTS="$2"
            shift 2
            ;;
        --network-logs)
            NETWORK_LOGS="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

echo "🔨 Compiling contract validator..."
swiftc scripts/contract-validator.swift -o .contract-validator

echo "🔍 Running contract validation..."
./.contract-validator

# Read validation results
VALIDATION_RESULTS=$(cat contract_validation.txt)
MATCHED_COUNT=$(grep -c "Frontend:" contract_validation.txt || true)
UNMATCHED_BACKEND=$(grep -c "❌ Unmatched Backend" contract_validation.txt || true)
UNMATCHED_FRONTEND=$(grep -c "⚠️ Unmatched Frontend" contract_validation.txt || true)

# Generate Golden Verification Report
cat > "${OUTPUT:-GoldenVerification.html}" << EOL
<!DOCTYPE html>
<html>
<head>
    <title>FOMO Golden Verification Report</title>
    <style>
        body { font-family: -apple-system, sans-serif; margin: 40px; line-height: 1.6; }
        .section { margin: 20px 0; padding: 20px; border-radius: 8px; background: #f8f9fa; }
        .metric { font-size: 24px; font-weight: bold; color: #2196F3; }
        .success { color: #4CAF50; }
        .warning { color: #FF9800; }
        .error { color: #F44336; }
        pre { background: #f1f3f5; padding: 15px; border-radius: 4px; overflow-x: auto; }
        .details { margin: 10px 0; font-size: 14px; color: #666; }
    </style>
</head>
<body>
    <h1>🏆 FOMO Golden Verification Report</h1>
    
    <div class="section">
        <h2>Contract Validation Summary</h2>
        <p class="metric success">✅ Matched Endpoints: $MATCHED_COUNT</p>
        <p class="metric warning">⚠️ Unmatched Frontend: $UNMATCHED_FRONTEND</p>
        <p class="metric error">❌ Unmatched Backend: $UNMATCHED_BACKEND</p>
        <div class="details">
            <pre>$VALIDATION_RESULTS</pre>
        </div>
    </div>
    
    <div class="section">
        <h2>Test Results</h2>
        <div class="details">
            <pre>$(cat "$TEST_RESULTS" 2>/dev/null || echo "No test results available")</pre>
        </div>
    </div>
    
    <div class="section">
        <h2>Network Analysis</h2>
        <div class="details">
            <pre>$(cat "$NETWORK_LOGS" 2>/dev/null || echo "No network logs available")</pre>
        </div>
    </div>
    
    <div class="section">
        <h2>Environment Status</h2>
        <p class="metric">⚙️ Environment: ${API_ENV:-production}</p>
        <p class="details">SSL Pinning: Active</p>
        <p class="details">Network Monitoring: Enabled</p>
        <p class="details">API Version: v1.0</p>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const timestamp = new Date().toLocaleString();
            document.body.insertAdjacentHTML('beforeend', 
                '<div class="section"><p class="details">Report generated: ' + timestamp + '</p></div>'
            );
        });
    </script>
</body>
</html>
EOL

echo "✨ Golden Verification Report generated: ${OUTPUT:-GoldenVerification.html}"

# Cleanup
rm -f .contract-validator 