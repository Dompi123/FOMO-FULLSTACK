#!/bin/zsh
# Guaranteed clean build

# 1. Fresh environment
./scripts/enforce_paths.sh
./scripts/cleanup_project.sh

# 2. Cache purge
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 3. Project generation
xcodegen generate --spec project.yml

# 4. Build with explicit paths
xcodebuild clean build \
    -project FOMO_FINAL.xcodeproj \
    -scheme FOMO_FINAL \
    -destination 'platform=iOS Simulator,name=FOMO Test iPhone' \
    DEVELOPMENT_ASSET_PATHS="$PWD/FOMO_FINAL/FOMO_FINAL/Preview Content" 