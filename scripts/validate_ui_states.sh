#!/bin/zsh

set -e  # Exit on any error

# Parse arguments
REQUIRED_ELEMENTS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --elements)
            shift
            while [[ $# -gt 0 ]] && [[ $1 != --* ]]; do
                REQUIRED_ELEMENTS+=("$1")
                shift
            done
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🔍 Validating UI states..."
echo "Required elements: ${REQUIRED_ELEMENTS[@]}"

# Get app container
APP_CONTAINER=$(xcrun simctl get_app_container booted com.fomo.FOMO-FINAL)
if [ -z "$APP_CONTAINER" ]; then
    echo "❌ Could not find app container in simulator"
    exit 1
fi

# Verify feature flags
if [ ! -f "$APP_CONTAINER/PreviewData/config.json" ]; then
    echo "❌ Missing feature flags configuration"
    exit 1
fi

# Load feature configuration
CONFIG=$(cat "$APP_CONTAINER/PreviewData/config.json")
DATA_VERSION=$(echo "$CONFIG" | grep -o '"dataVersion": *"[^"]*"' | cut -d'"' -f4)
echo "📱 Validating against data version: $DATA_VERSION"

# Verify UI elements
echo "📱 Checking UI elements..."
UI_DUMP=$(xcrun simctl ui booted dump)

for element in "${REQUIRED_ELEMENTS[@]}"; do
    # Split element into component and subtype
    COMPONENT=$(echo "$element" | cut -d'.' -f1)
    SUBTYPE=$(echo "$element" | cut -d'.' -f2)
    
    case $COMPONENT in
        "PaymentState")
            echo "💳 Checking payment state: $SUBTYPE"
            if ! echo "$UI_DUMP" | grep -q "PaymentState.$SUBTYPE"; then
                echo "❌ Missing payment state: $SUBTYPE"
                exit 1
            fi
            ;;
        "DrinkMenu")
            echo "🍸 Checking drink menu: $SUBTYPE"
            if [ ! -f "$APP_CONTAINER/Drinks/Drinks.json" ]; then
                echo "❌ Missing drinks data"
                exit 1
            fi
            if ! echo "$UI_DUMP" | grep -q "DrinkMenu.$SUBTYPE"; then
                echo "❌ Missing drink menu element: $SUBTYPE"
                exit 1
            fi
            ;;
        "Checkout")
            echo "🛒 Checking checkout: $SUBTYPE"
            if ! echo "$UI_DUMP" | grep -q "Checkout.$SUBTYPE"; then
                echo "❌ Missing checkout element: $SUBTYPE"
                exit 1
            fi
            ;;
        "NewFeature")
            echo "✨ Checking new feature: $SUBTYPE"
            if [ ! -d "$APP_CONTAINER/NewFeatures" ]; then
                echo "❌ Missing new features directory"
                exit 1
            fi
            if ! echo "$UI_DUMP" | grep -q "NewFeature.$SUBTYPE"; then
                echo "❌ Missing new feature element: $SUBTYPE"
                exit 1
            fi
            ;;
        *)
            if ! echo "$UI_DUMP" | grep -q "$element"; then
                echo "❌ Missing required element: $element"
                exit 1
            fi
            ;;
    esac
    echo "✅ Verified element: $element"
done

echo "✅ All UI states validated successfully!"
exit 0 