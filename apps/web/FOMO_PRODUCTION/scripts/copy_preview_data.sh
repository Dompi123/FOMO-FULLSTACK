#!/bin/bash

# Create PreviewData directory in the app bundle if it doesn't exist
mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/PreviewData"

# Copy preview data files
cp "${PROJECT_DIR}/PreviewData/FixedData.json" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/PreviewData/"
cp "${PROJECT_DIR}/PreviewData/FullContext.json" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/PreviewData/"

# Create JourneyData directory in the app bundle if it doesn't exist
mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/JourneyData"

# Copy journey data files
cp "${PROJECT_DIR}/JourneyData/Venues.json" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/JourneyData/"
cp "${PROJECT_DIR}/JourneyData/Passes.json" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/JourneyData/"

echo "Preview and journey data files copied successfully." 