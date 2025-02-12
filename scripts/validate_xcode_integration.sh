#!/bin/zsh
set -e

echo "🔍 Validating Xcode project integration..."

# Check project file structure
check_project_reference() {
    if ! plutil -extract objects xml1 -o - FOMO_FINAL.xcodeproj/project.pbxproj | grep -q "$1"; then
        echo "❌ Missing project reference: $1"
        exit 1
    fi
}

# Check core model files
echo "\nChecking model files..."
check_project_reference "Venue.swift"
check_project_reference "Pass.swift"
check_project_reference "UserProfile.swift"
check_project_reference "PreviewDataLoader.swift"

# Check view files
echo "\nChecking view files..."
check_project_reference "VenueListView.swift"
check_project_reference "PassesView.swift"
check_project_reference "ProfileView.swift"

# Check view model files
echo "\nChecking view model files..."
check_project_reference "VenueListViewModel.swift"
check_project_reference "PassesViewModel.swift"
check_project_reference "ProfileViewModel.swift"

echo "\n✅ All required files are properly referenced in the Xcode project!" 