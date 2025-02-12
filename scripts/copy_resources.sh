#!/bin/sh

# Get simulator app container
APP_CONTAINER=$(xcrun simctl get_app_container booted fomo.FOMO-FINAL)
echo "Copying resources to: ${APP_CONTAINER}"

# Create necessary directories
mkdir -p "${APP_CONTAINER}/Resources/JourneyData/Passes"
mkdir -p "${APP_CONTAINER}/Resources/JourneyData/Profile"
mkdir -p "${APP_CONTAINER}/Drinks"

# Copy JSON files
echo "Copying JSON files..."

# Copy Drinks.json
if [ -f "FOMO_FINAL/PreviewData/Drinks/Drinks.json" ]; then
    cp "FOMO_FINAL/PreviewData/Drinks/Drinks.json" "${APP_CONTAINER}/Drinks/"
    echo "✅ Copied Drinks.json successfully"
else
    echo "❌ Error: Drinks.json not found at source location"
fi

# Verify the files were copied
echo "Verifying copied files..."
ls -l "${APP_CONTAINER}/Drinks"

echo "Resource files copy completed!" 