#!/bin/zsh

set -e  # Exit on any error

echo "🔧 Fixing project structure..."

# Set up project paths
PROJECT_ROOT="$(pwd)"
PREVIEW_ROOT="$PROJECT_ROOT/FOMO_FINAL/FOMO_FINAL/Preview Content"
RESOURCES_ROOT="$PROJECT_ROOT/FOMO_FINAL/FOMO_FINAL/Resources"

# Create required directories
echo "📁 Creating required directories..."
mkdir -p "$PREVIEW_ROOT/PreviewData"
mkdir -p "$PREVIEW_ROOT/Assets"
mkdir -p "$RESOURCES_ROOT"

# Create .keep files to preserve directory structure
touch "$PREVIEW_ROOT/PreviewData/.keep"
touch "$PREVIEW_ROOT/Assets/.keep"
touch "$RESOURCES_ROOT/.keep"

# Clean up any stray files
echo "🧹 Cleaning up stray files..."
find . -name ".DS_Store" -delete 2>/dev/null || true
find . -name "*.xcuserstate" -delete 2>/dev/null || true

# Regenerate project
echo "🔄 Regenerating project..."
if command -v xcodegen >/dev/null 2>&1; then
    xcodegen generate
else
    echo "⚠️  xcodegen not found - skipping project generation"
fi

echo "✅ Project structure fixed!"
echo "Next steps:"
echo "1. Update project.pbxproj with new file references"
echo "2. Run build to verify structure"
echo "3. Complete remaining file migrations" 