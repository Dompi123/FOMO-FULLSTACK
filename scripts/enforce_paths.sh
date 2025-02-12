#!/bin/zsh
# Enforces canonical preview paths

CANONICAL_PATH="FOMO_FINAL/FOMO_FINAL/Preview Content"

# 1. Remove legacy paths
rm -rf "{Preview,preview,FOMO_FINAL/Preview}" 2>/dev/null

# 2. Create canonical structure
mkdir -p "$CANONICAL_PATH" || true
touch "$CANONICAL_PATH/.keep"

# 3. Update configurations
sed -i '' "s|DEVELOPMENT_ASSET_PATHS:.*|DEVELOPMENT_ASSET_PATHS: \"$CANONICAL_PATH\"|" project.yml
sed -i '' "s|PREVIEW_DATA_PATH =.*|PREVIEW_DATA_PATH = \$(SRCROOT)/$CANONICAL_PATH|" FOMO_FINAL.xcconfig

# 4. Create symlink for legacy references
ln -sfh "$PWD/$CANONICAL_PATH" Preview 