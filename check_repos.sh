#!/bin/bash
# check_repos.sh - Show status of all simple_* repos (dry run, no changes made)

PROD_ROOT="/d/prod"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=============================================="
echo "Simple Ecosystem Repository Status"
echo "=============================================="
echo ""

total=0
with_changes=0
clean=0

for dir in "$PROD_ROOT"/simple_*; do
    if [ -d "$dir" ] && [ -d "$dir/.git" ]; then
        repo_name=$(basename "$dir")
        ((total++))

        cd "$dir" || continue

        changes=$(git status --porcelain 2>/dev/null)

        if [ -z "$changes" ]; then
            ((clean++))
        else
            ((with_changes++))
            file_count=$(echo "$changes" | wc -l)
            echo -e "${YELLOW}$repo_name${NC} ($file_count files):"
            echo "$changes" | head -10
            if [ $(echo "$changes" | wc -l) -gt 10 ]; then
                echo "  ... and more"
            fi
            echo ""
        fi
    fi
done

echo "=============================================="
echo "Summary: $with_changes repos with changes, $clean clean (of $total total)"
echo "=============================================="
