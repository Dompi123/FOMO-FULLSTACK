#!/bin/zsh

set -e  # Exit on any error

# Configuration
PREVIEW_DIR="FOMO_FINAL/Preview Content"
XCODEPROJ_PATH="FOMO_FINAL/FOMO_FINAL.xcodeproj/project.pbxproj"
BACKUP_PATH="$XCODEPROJ_PATH.backup"

echo "🔄 Setting up Sweetpad preview paths..."

# Backup project file
echo "📦 Creating backup..."
cp "$XCODEPROJ_PATH" "$BACKUP_PATH"

# Create Preview Content directory
echo "📁 Creating preview directory..."
mkdir -p "$PREVIEW_DIR"
touch "$PREVIEW_DIR/.keep"

# Update Xcode project file
echo "🛠 Updating Xcode project..."
if [ "$(uname)" = "Darwin" ]; then
    # macOS version using sed
    sed -i '' 's/DEVELOPMENT_ASSET_PATHS = ".*";/DEVELOPMENT_ASSET_PATHS = "$(SRCROOT)\/Preview Content";/g' "$XCODEPROJ_PATH"
else
    # Linux version
    sed -i 's/DEVELOPMENT_ASSET_PATHS = ".*";/DEVELOPMENT_ASSET_PATHS = "$(SRCROOT)\/Preview Content";/g' "$XCODEPROJ_PATH"
fi

# Verify changes
echo "🔍 Verifying changes..."
if ./scripts/verify_sweetpad_paths.sh; then
    echo "✅ Setup completed successfully!"
    rm "$BACKUP_PATH"
else
    echo "❌ Verification failed! Rolling back changes..."
    mv "$BACKUP_PATH" "$XCODEPROJ_PATH"
    exit 1
fi 