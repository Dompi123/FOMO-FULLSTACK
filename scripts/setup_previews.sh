#!/bin/bash

set -e  # Exit on any error

# Directory structure
BASE_DIR="Sources/FOMO_FINAL"
FEATURES_DIR="$BASE_DIR/Features"
VENUES_DIR="$FEATURES_DIR/Venues"
VIEWS_DIR="$VENUES_DIR/Views"
PAYWALL_DIR="$VIEWS_DIR/Paywall"
PREVIEW_DIR="FOMO_FINAL/Preview Content"
PREVIEW_ASSETS_DIR="$PREVIEW_DIR/Preview Assets.xcassets"
PREVIEW_FILE="$PREVIEW_DIR/PaywallView+Preview.swift"

echo "🔄 Setting up preview content..."

# Create all necessary directories
echo "📁 Creating directory structure..."
for dir in "$BASE_DIR" "$FEATURES_DIR" "$VENUES_DIR" "$VIEWS_DIR" "$PAYWALL_DIR" "$PREVIEW_DIR" "$PREVIEW_ASSETS_DIR"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "  Created: $dir"
    else
        echo "  Exists: $dir"
    fi
done

# Create preview file directly in Preview Content
echo "📝 Creating preview file..."
PREVIEW_CONTENT='import SwiftUI

#if DEBUG
struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(venue: .mock)
            .environmentObject(PaymentManager.preview)
    }
}
#endif'

echo "$PREVIEW_CONTENT" > "$PREVIEW_FILE"

# Create Preview Assets catalog if it doesn't exist
if [ ! -f "$PREVIEW_ASSETS_DIR/Contents.json" ]; then
    echo "📝 Creating Preview Assets catalog..."
    echo '{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}' > "$PREVIEW_ASSETS_DIR/Contents.json"
fi

# Create symlink in the Paywall directory
echo "🔗 Creating symlink..."
ln -sf "../../../FOMO_FINAL/Preview Content/PaywallView+Preview.swift" "$PAYWALL_DIR/PaywallView+Preview.swift"

echo "🔒 Setting permissions..."
chmod -R 755 "$PREVIEW_DIR"

echo "✅ Preview content setup complete!"
echo "Preview files are now in: $PREVIEW_DIR"
ls -la "$PREVIEW_DIR" 