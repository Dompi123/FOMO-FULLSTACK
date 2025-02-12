#!/bin/zsh
APP_CONTAINER=$(xcrun simctl get_app_container booted fomo.FOMO-FINAL)

check_preview_data() {
    echo "🔍 Checking $1..."
    [ -f "$APP_CONTAINER/$1" ] || { echo "❌ Missing $1"; exit 1; }
    CONTENT=$(cat "$APP_CONTAINER/$1")
    if [[ "$CONTENT" != *"Mojito"* ]]; then
        echo "❌ Invalid drink menu data"
        exit 1
    fi
}

check_preview_data "Drinks/Drinks.json"
check_preview_data "Resources/JourneyData/Venues.json"
check_preview_data "Resources/JourneyData/Passes/Passes.json"
check_preview_data "Resources/JourneyData/Profile/Profile.json"

# Verify UI elements
xcrun simctl ui booted capture | grep -q "Mojito" || exit 1
xcrun simctl ui booted capture | grep -q "Old Fashioned" || exit 1

echo "✅ All preview data integrated!" && exit 0 