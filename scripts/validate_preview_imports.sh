#!/bin/zsh
set -e

echo "🔍 Validating and fixing preview imports..."

# Function to add imports if needed
fix_imports() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    if ! grep -q "^@testable import FOMO_FINAL" "$file" && ! grep -q "^import FOMO_FINAL" "$file"; then
        echo "Adding import to $file"
        awk '
            NR == 1 { print "@testable import FOMO_FINAL" }
            { print }
        ' "$file" > "$temp_file" && mv "$temp_file" "$file"
    fi
}

# Find all preview files
echo "Finding preview files..."
find FOMO_FINAL -name "*.swift" -type f -exec grep -l "PreviewProvider" {} \; | while read -r file; do
    fix_imports "$file"
done

echo "✅ Preview imports validation complete!" 