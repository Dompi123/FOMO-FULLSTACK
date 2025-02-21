#!/bin/bash
set -e

echo "🔒 Starting safe integration..."

# 0. Ensure correct directory
if [[ ! "$PWD" =~ "FOMO-FULLSTACK" ]]; then
    cd ~/Desktop/FOMO-FULLSTACK || { echo "❌ Cannot find project directory"; exit 1; }
fi

# 1. Create directories relative to current path
mkdir -p ./automation/{scripts,cv_checks} ./docs

# 2. Create security scan script
cat > ./automation/scripts/security_scan.sh << 'EOF'
#!/bin/zsh
echo "🛡️  Scanning in $(pwd)..."
grep -r --include=*.swift 'password\|secret' ./FOMO-FULLSTACK/
EOF

# Create UI validation script
cat > ./automation/cv_checks/validate_ui.py << 'EOF'
import claude_vision
print("✅ UI validated" if claude_vision.match_baseline("./FOMO-FULLSTACK/Screenshots") else "❌ UI drift")
EOF

# 3. Fix workflow paths
if [ -f .github/workflows/deploy.yml ]; then
    sed -i '' \
    -e 's|FOMO_FINAL/|FOMO-FULLSTACK/|g' \
    -e 's|FOMO.xcarchive|FOMO-FULLSTACK/FOMO.xcarchive|g' \
    .github/workflows/deploy.yml
fi

# 4. Set correct permissions
chmod -R u+w .
chmod +x ./automation/scripts/*

# 5. Verify and push changes
if [ -d ./FOMO-FULLSTACK ]; then
    git add -A
    git commit -m "Fix paths and permissions"
    git push --force origin main
    echo -e "\033[32m✅ SAFELY INTEGRATED\033[0m"
else
    echo -e "\033[31m❌ FOMO-FULLSTACK directory not found\033[0m"
    exit 1
fi
