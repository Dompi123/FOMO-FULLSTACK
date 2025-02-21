#!/bin/zsh
echo "🛡️  Scanning in $(pwd)..."
grep -r --include=*.swift 'password\|secret' ./FOMO-FULLSTACK/
