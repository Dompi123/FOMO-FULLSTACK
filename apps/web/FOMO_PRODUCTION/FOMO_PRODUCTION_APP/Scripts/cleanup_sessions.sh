#!/bin/zsh

# Script to cleanup expired collaboration sessions
# Usage: ./cleanup_sessions.sh --max-age 24h

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --max-age)
            MAX_AGE="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

# Validate max age
if [[ -z "$MAX_AGE" ]]; then
    echo "Error: --max-age is required"
    exit 1
fi

# Convert max age to seconds
case $MAX_AGE in
    *h)
        SECONDS=${MAX_AGE%h}
        SECONDS=$((SECONDS * 3600))
        ;;
    *d)
        SECONDS=${MAX_AGE%d}
        SECONDS=$((SECONDS * 86400))
        ;;
    *)
        echo "Error: Invalid max age format. Use h for hours or d for days"
        exit 1
        ;;
esac

echo "Cleaning up sessions older than $MAX_AGE..."

# Find and remove expired sessions
cursor collab list --json | jq -r ".[] | select(.created_at < now-$SECONDS) | .id" | while read -r session_id; do
    echo "Removing session: $session_id"
    cursor collab delete "$session_id"
done

echo "Cleanup complete!"

# Log cleanup
echo "$(date): Cleaned up sessions older than $MAX_AGE" >> .cursor/logs/session_cleanup.log 