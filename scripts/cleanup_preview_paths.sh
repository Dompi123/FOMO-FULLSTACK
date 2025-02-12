#!/bin/zsh
set -e

echo "🧹 Cleaning up preview paths..."

# Get absolute path to project root
PROJECT_ROOT="$(pwd)"
PREVIEW_ROOT="$PROJECT_ROOT/FOMO_FINAL/FOMO_FINAL/Preview Content"

# 1. Remove all preview-related directories
echo "Removing existing preview directories..."
find . -type d -name "Preview Content" -exec rm -rf {} +
find . -type d -name "PreviewData" -exec rm -rf {} +
find . -type d -name "Preview" -exec rm -rf {} +

# 2. Create canonical preview structure
echo "Creating canonical preview structure..."
mkdir -p "$PREVIEW_ROOT"
mkdir -p "$PREVIEW_ROOT/PreviewData"
mkdir -p "$PREVIEW_ROOT/Assets/test_assets.xcassets"

# 3. Create initial content
echo "Creating initial content..."
cat > "$PREVIEW_ROOT/PreviewData/sample_drinks.json" << 'EOF'
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
    },
    {
      "id": "drink_2",
      "name": "Classic Martini",
      "description": "Gin or vodka with dry vermouth and olive garnish",
      "price": 14.99,
      "category": "Cocktails",
      "imageUrl": "drink_martini",
      "available": true
    },
    {
      "id": "drink_3",
      "name": "House Red Wine",
      "description": "Premium California Cabernet Sauvignon",
      "price": 9.99,
      "category": "Wine",
      "imageUrl": "drink_wine",
      "available": true
    }
  ],
  "categories": [
    "Cocktails",
    "Wine",
    "Beer",
    "Non-Alcoholic"
  ]
}
EOF

# 4. Create asset catalog structure
echo "Creating asset catalog structure..."
cat > "$PREVIEW_ROOT/Assets/test_assets.xcassets/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create image asset directories
for img in drink_mojito drink_martini drink_wine; do
    mkdir -p "$PREVIEW_ROOT/Assets/test_assets.xcassets/$img.imageset"
    cat > "$PREVIEW_ROOT/Assets/test_assets.xcassets/$img.imageset/Contents.json" << EOF
{
  "images" : [
    {
      "idiom" : "universal",
      "scale" : "1x",
      "filename" : "$img.pdf"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  },
  "properties" : {
    "preserves-vector-representation" : true
  }
}
EOF
done

# 5. Create .keep file
echo "Creating .keep file..."
cat > "$PREVIEW_ROOT/.keep" << 'EOF'
Preview Content Assets:

1. PreviewData/
   - sample_drinks.json (Drink menu and categories)

2. Assets/test_assets.xcassets/
   - drink_mojito.imageset/
   - drink_martini.imageset/
   - drink_wine.imageset/

Note: PDF vector assets are used for high-quality scaling
EOF

echo "✅ Preview paths cleanup complete!" 