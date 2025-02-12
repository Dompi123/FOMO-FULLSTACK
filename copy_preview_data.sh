#!/bin/bash

# Source directories
WORKSPACE_DIR="$PWD"
SOURCE_DIR="$WORKSPACE_DIR/FOMO_FINAL/FOMO_FINAL"
JOURNEY_DATA_DIR="$SOURCE_DIR/JourneyData"
PREVIEW_DATA_DIR="$SOURCE_DIR/PreviewData"

# Build destination directory
BUILD_DIR="$WORKSPACE_DIR/FOMO_FINAL/build/Debug-iphonesimulator/FOMO_FINAL.app"

# Simulator destination directory (we'll get this dynamically)
SIM_APP_DIR=$(xcrun simctl get_app_container "FOMO Preview" "fomo.FOMO-FINAL")

echo "Creating directories in build and simulator locations..."

# Create directories in build location
mkdir -p "$BUILD_DIR/JourneyData"
mkdir -p "$BUILD_DIR/PreviewData"

# Create directories in simulator location
mkdir -p "$SIM_APP_DIR/JourneyData"
mkdir -p "$SIM_APP_DIR/PreviewData"

echo "Copying journey data files..."

# Copy Venues.json
if [ -f "$JOURNEY_DATA_DIR/Venues.json" ]; then
    echo "Found Venues.json at $JOURNEY_DATA_DIR/Venues.json"
    cp "$JOURNEY_DATA_DIR/Venues.json" "$BUILD_DIR/JourneyData/"
    cp "$JOURNEY_DATA_DIR/Venues.json" "$SIM_APP_DIR/JourneyData/"
    echo "Successfully copied Venues.json to both locations"
else
    echo "Warning: Venues.json not found at $JOURNEY_DATA_DIR/Venues.json"
fi

# Copy Passes.json
if [ -f "$JOURNEY_DATA_DIR/Passes.json" ]; then
    echo "Found Passes.json at $JOURNEY_DATA_DIR/Passes.json"
    cp "$JOURNEY_DATA_DIR/Passes.json" "$BUILD_DIR/JourneyData/"
    cp "$JOURNEY_DATA_DIR/Passes.json" "$SIM_APP_DIR/JourneyData/"
    echo "Successfully copied Passes.json to both locations"
else
    echo "Warning: Passes.json not found at $JOURNEY_DATA_DIR/Passes.json"
fi

echo "Copying preview data files..."

# Copy FixedData.json
if [ -f "$PREVIEW_DATA_DIR/FixedData.json" ]; then
    echo "Found FixedData.json"
    cp "$PREVIEW_DATA_DIR/FixedData.json" "$BUILD_DIR/PreviewData/"
    cp "$PREVIEW_DATA_DIR/FixedData.json" "$SIM_APP_DIR/PreviewData/"
else
    echo "Warning: FixedData.json not found"
fi

# Copy FullContext.json
if [ -f "$PREVIEW_DATA_DIR/FullContext.json" ]; then
    echo "Found FullContext.json"
    cp "$PREVIEW_DATA_DIR/FullContext.json" "$BUILD_DIR/PreviewData/"
    cp "$PREVIEW_DATA_DIR/FullContext.json" "$SIM_APP_DIR/PreviewData/"
else
    echo "Warning: FullContext.json not found"
fi

echo "Verifying files..."
echo "Build directory contents:"
ls -l "$BUILD_DIR/JourneyData"
ls -l "$BUILD_DIR/PreviewData"

echo "Simulator directory contents:"
ls -l "$SIM_APP_DIR/JourneyData"
ls -l "$SIM_APP_DIR/PreviewData"

echo "Copy process completed" 