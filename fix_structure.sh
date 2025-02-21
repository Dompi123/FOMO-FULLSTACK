#!/bin/bash

# Set error handling
set -e
echo -e "\033[34m🔧 Starting structure fix...\033[0m"

# 1. Correct directory structure
cd ~/Desktop
echo -e "\033[34m📁 Renaming directory...\033[0m"
mv "fomofinal copy" FOMO-FULLSTACK
cd FOMO-FULLSTACK

# 2. Fix workflow paths
echo -e "\033[34m📝 Updating workflow paths...\033[0m"
mkdir -p .github/workflows
cat > .github/workflows/deploy.yml << 'EOF'
name: FOMO Auto-Deploy

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    name: Build and Test
    runs-on: macos-latest
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Xcode
        uses: maxim-lobanov/setup-xcode@v1
        with:
          xcode-version: '15.0'

      - name: List workspace contents
        run: |
          pwd
          ls -la
          echo "Project structure:"
          find . -name "*.xcodeproj"
          echo "Available schemes:"
          xcodebuild -project ./FOMO_PRODUCTION.xcodeproj -list

      - name: Install dependencies
        run: |
          brew install swiftlint
          brew install xcbeautify

      - name: Build project
        run: |
          xcodebuild clean build \
            -project ./FOMO_PRODUCTION.xcodeproj \
            -scheme "FOMO_PRODUCTION" \
            -destination "platform=iOS Simulator,name=iPhone 15 Pro,OS=17.0" \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO \
            | xcbeautify

      - name: Upload build artifacts
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: build-logs
          path: ~/Library/Developer/Xcode/DerivedData/
EOF

# 3. Align git remote
echo -e "\033[34m🔄 Updating git remote...\033[0m"
git remote set-url origin https://github.com/Dompi123/FOMO-FULLSTACK.git

# 4. Force push correct structure
echo -e "\033[34m📤 Pushing changes...\033[0m"
git add -A
git commit -m "Final path alignment"
git push --force origin main

# 5. Post-verification
echo -e "\033[34m✅ Opening Actions page...\033[0m"
open "https://github.com/Dompi123/FOMO-FULLSTACK/actions"
gh run watch

echo -e "\033[32m✅ STRUCTURE FIXED - Monitor workflow run\033[0m"
