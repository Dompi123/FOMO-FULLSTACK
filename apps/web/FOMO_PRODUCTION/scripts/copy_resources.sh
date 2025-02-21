#!/bin/sh

# Create necessary directories in the app bundle
mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/JourneyData/Passes"
mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/JourneyData/Profile"

# Copy JSON files to their respective locations
echo "Copying JSON files to app bundle..."

# Copy Venues.json
cp "${SRCROOT}/FOMO_FINAL/Resources/JourneyData/Venues.json" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/JourneyData/"

# Copy Passes.json
cp "${SRCROOT}/FOMO_FINAL/Resources/JourneyData/Passes/Passes.json" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/JourneyData/Passes/"

# Copy Profile.json
cp "${SRCROOT}/FOMO_FINAL/Resources/JourneyData/Profile/Profile.json" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/JourneyData/Profile/"

echo "Resource files copied successfully!" 