#!/bin/zsh
APP_CONTAINER=$(xcrun simctl get_app_container booted com.fomo.FOMO-FINAL)

check_file() {
  [ -f "$APP_CONTAINER/$1" ] || { echo "❌ Missing $1"; exit 1; }
}

check_file "JourneyData/Venues.json"
check_file "Passes/Passes.json" 
check_file "Profile/Profile.json"

# UI Element Verification
xcrun simctl ui booted capture | grep -q "My Passes" || exit 1
xcrun simctl ui booted capture | grep -q "Preview User" || exit 1

echo "✅ All data verified!" && exit 0 