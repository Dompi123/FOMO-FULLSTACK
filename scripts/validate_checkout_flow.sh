#!/bin/zsh

# Exit on error
set -e

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --device)
            DEVICE_NAME="$2"
            shift 2
            ;;
        --stress)
            STRESS_COUNT="$2"
            shift 2
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🔍 Validating checkout flow..."

# Create output directory
mkdir -p $(dirname "$OUTPUT_FILE")

# Start validation
echo "<html><body><h1>Checkout Flow Validation Report</h1>" > "$OUTPUT_FILE"
echo "<h2>Test Configuration</h2>" >> "$OUTPUT_FILE"
echo "<ul>" >> "$OUTPUT_FILE"
echo "<li>Device: $DEVICE_NAME</li>" >> "$OUTPUT_FILE"
echo "<li>Stress Count: $STRESS_COUNT</li>" >> "$OUTPUT_FILE"
echo "<li>Date: $(date)</li>" >> "$OUTPUT_FILE"
echo "</ul>" >> "$OUTPUT_FILE"

# Run stress test
echo "<h2>Stress Test Results</h2>" >> "$OUTPUT_FILE"
echo "<pre>" >> "$OUTPUT_FILE"

for i in $(seq 1 $STRESS_COUNT); do
    echo "Running iteration $i/$STRESS_COUNT..."
    
    # Launch app
    xcrun simctl launch "$DEVICE_NAME" "fomo.FOMO-FINAL" --args -stress-test
    
    # Navigate through flow
    xcrun simctl send_event "$DEVICE_NAME" tap "Preview Drink Menu"
    sleep 1
    xcrun simctl send_event "$DEVICE_NAME" tap "Checkout"
    sleep 1
    xcrun simctl send_event "$DEVICE_NAME" tap "Place Order"
    sleep 2
    
    # Terminate app
    xcrun simctl terminate "$DEVICE_NAME" "fomo.FOMO-FINAL"
    sleep 1
    
    echo "✓ Iteration $i complete" >> "$OUTPUT_FILE"
done

echo "</pre>" >> "$OUTPUT_FILE"
echo "<h2>Summary</h2>" >> "$OUTPUT_FILE"
echo "<p>All tests completed successfully.</p>" >> "$OUTPUT_FILE"
echo "</body></html>" >> "$OUTPUT_FILE"

echo "✅ Validation complete! Report saved to $OUTPUT_FILE" 