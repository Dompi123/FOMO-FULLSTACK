#!/bin/zsh
set -e

echo "🔍 Validating preview paths..."

# Get absolute path to project root
PROJECT_ROOT="$(pwd)"
PREVIEW_ROOT="$PROJECT_ROOT/FOMO_FINAL/FOMO_FINAL/Preview Content"

# Create directories if they don't exist
create_directories() {
    echo "📁 Creating required directories..."
    REQUIRED_DIRS=(
        "$PREVIEW_ROOT"
        "$PREVIEW_ROOT/PreviewData"
        "$PREVIEW_ROOT/Assets"
        "$PREVIEW_ROOT/Assets/test_assets.xcassets"
    )

    for dir in "${REQUIRED_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            echo "Creating: $dir"
            mkdir -p "$dir"
        fi
    done
}

# Verify project.yml paths
verify_project_config() {
    echo "📝 Verifying project configuration..."
    if [ ! -f "project.yml" ]; then
        echo "❌ Error: project.yml not found"
        exit 1
    }

    REQUIRED_SETTINGS=(
        "DEVELOPMENT_ASSET_PATHS.*Preview Content"
        "PREVIEW_DATA_PATH.*PreviewData"
        "ASSET_CATALOGS.*Assets"
    )

    for setting in "${REQUIRED_SETTINGS[@]}"; do
        if ! grep -q "$setting" "project.yml"; then
            echo "❌ Error: Missing required setting: $setting"
            exit 1
        fi
    done
}

# Create initial preview data if missing
create_preview_data() {
    echo "📊 Setting up preview data..."
    SAMPLE_DATA="$PREVIEW_ROOT/PreviewData/sample_drinks.json"
    
    if [ ! -f "$SAMPLE_DATA" ]; then
        echo "Creating sample data..."
        cat > "$SAMPLE_DATA" << 'EOF'
{
  "drinks": [
    {
      "id": "drink_1",
      "name": "Signature Mojito",
      "description": "Fresh mint, lime juice, rum, and soda water",
      "price": 12.99,
      "category": "Cocktails",
      "imageUrl": "drink_mojito",
      "available": true
    }
  ],
  "categories": ["Cocktails", "Wine", "Beer", "Non-Alcoholic"]
}
EOF
    fi
}

# Create asset catalog structure
create_asset_catalog() {
    echo "🎨 Setting up asset catalog..."
    ASSETS_DIR="$PREVIEW_ROOT/Assets/test_assets.xcassets"
    
    if [ ! -f "$ASSETS_DIR/Contents.json" ]; then
        echo "Creating asset catalog structure..."
        mkdir -p "$ASSETS_DIR"
        cat > "$ASSETS_DIR/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
    fi
}

# Main execution
create_directories
verify_project_config
create_preview_data
create_asset_catalog

echo "✅ Preview paths validation complete!" 