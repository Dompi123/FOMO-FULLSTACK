#!/bin/zsh
# Enforces canonical structure

SRCROOT="$PWD"
CANONICAL_PREVIEW="FOMO_FINAL/FOMO_FINAL/Resources/PreviewContent"

REQUIRED_PATHS=(
  "$CANONICAL_PREVIEW"
  "$CANONICAL_PREVIEW/Data"
  "$CANONICAL_PREVIEW/Assets"
)

for path in "${REQUIRED_PATHS[@]}"; do
  if [ ! -d "$path" ]; then
    echo "❌ Missing required path: $path"
    /bin/mkdir -p "$path"
    echo "⚠️ Auto-created missing directory"
  fi
done

# Verify config alignment
if ! /usr/bin/grep -q "DEVELOPMENT_ASSET_PATHS.*$CANONICAL_PREVIEW" project.yml; then
  echo "❌ Project config mismatch - repairing..."
  /usr/bin/sed -i '' "s|DEVELOPMENT_ASSET_PATHS:.*|DEVELOPMENT_ASSET_PATHS: \"$CANONICAL_PREVIEW\"|" project.yml
fi

echo "✅ Path validation complete!" 