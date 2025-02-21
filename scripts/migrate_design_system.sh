#!/bin/bash

# Migration script for FOMO design system unification

echo "Starting design system migration..."

# Phase 1: Typography Migration
echo "Phase 1: Migrating Typography..."
find . -name '*.swift' -type f -exec sed -i '' \
    -e 's/FOMOTypography\./FOMOTheme.Typography./g' \
    -e 's/import FOMOTypography//g' {} +

# Phase 2: Colors Migration
echo "Phase 2: Migrating Colors..."
find . -name '*.swift' -type f -exec sed -i '' \
    -e 's/FOMOColors\./FOMOTheme.Colors./g' \
    -e 's/import FOMOColors//g' {} +

# Phase 3: Update imports
echo "Phase 3: Updating imports..."
find . -name '*.swift' -type f -exec sed -i '' \
    -e '/import.*FOMOTheme/!s/^import SwiftUI$/import SwiftUI\nimport FOMOTheme/' {} +

# Phase 4: Clean up old files
echo "Phase 4: Cleaning up old files..."
rm -f FOMO_FINAL/Core/Design/Typography.swift
rm -f FOMO_FINAL/Core/UI/FOMOColors.swift

# Phase 5: Update Package.swift
echo "Phase 5: Updating Package.swift..."
sed -i '' '/.*FOMOColors.*/d' Package.swift
sed -i '' '/.*FOMOTypography.*/d' Package.swift

echo "Migration complete!"
echo "Please review changes and run tests to ensure everything works correctly." 