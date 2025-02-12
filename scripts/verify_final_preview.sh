#!/bin/bash

# Make script exit on first error
set -e

# Check if the app is running
if ! xcrun simctl spawn booted launchctl print system | grep -q "fomo.FOMO-FINAL"; then
  echo "Error: App is not running"
  exit 1
fi

# Check if the app bundle exists
APP_PATH=$(xcrun simctl get_app_container booted fomo.FOMO-FINAL)
if [ ! -d "$APP_PATH" ]; then
  echo "Error: App bundle not found"
  exit 1
fi

# Verify app version
APP_VERSION=$(defaults read "$APP_PATH/Info" CFBundleShortVersionString)
if [ "$APP_VERSION" != "1.0" ]; then
  echo "Error: Unexpected app version: $APP_VERSION"
  exit 1
fi

echo "Preview verification successful!"
exit 0 