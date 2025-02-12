#!/bin/zsh
# Full-system validation

# Phase 1: Path validation
./scripts/verify_preview_paths.sh

# Phase 2: Project integrity
./scripts/validate_xcode_integration.sh

# Phase 3: Build validation
./scripts/final_validation.sh

# Phase 4: Preview verification
./scripts/final_preview_validation.sh

# Phase 5: Generate report
./scripts/run_validation.sh 