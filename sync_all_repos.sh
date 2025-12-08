#!/bin/bash
# sync_all_repos.sh - Commit and push changes for all simple_* projects
# Usage: ./sync_all_repos.sh [commit_message]

PROD_ROOT="/d/prod"
COMMIT_MSG="${1:-Auto-sync: testing and configuration updates}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
total=0
with_changes=0
pushed=0
failed=0

# Arrays for reporting
declare -a pushed_repos
declare -a failed_repos
declare -a no_changes_repos

echo "=============================================="
echo "Simple Ecosystem Repository Sync"
echo "Started: $TIMESTAMP"
echo "Commit message: $COMMIT_MSG"
echo "=============================================="
echo ""

# Iterate through all simple_* directories
for dir in "$PROD_ROOT"/simple_*; do
    if [ -d "$dir" ]; then
        repo_name=$(basename "$dir")
        ((total++))

        # Check if it's a git repo
        if [ ! -d "$dir/.git" ]; then
            echo -e "${YELLOW}SKIP${NC}: $repo_name (not a git repo)"
            continue
        fi

        cd "$dir" || continue

        # Check for changes (staged, unstaged, or untracked)
        changes=$(git status --porcelain 2>/dev/null)

        if [ -z "$changes" ]; then
            no_changes_repos+=("$repo_name")
            continue
        fi

        ((with_changes++))

        echo -e "${BLUE}Processing${NC}: $repo_name"

        # Show what's being committed
        file_count=$(echo "$changes" | wc -l)
        echo "  Files changed: $file_count"

        # Stage all changes
        git add -A

        # Commit
        if git commit -m "$COMMIT_MSG" > /dev/null 2>&1; then
            # Push
            if git push origin HEAD 2>/dev/null; then
                echo -e "  ${GREEN}PUSHED${NC}"
                ((pushed++))
                pushed_repos+=("$repo_name ($file_count files)")
            else
                echo -e "  ${RED}PUSH FAILED${NC}"
                ((failed++))
                failed_repos+=("$repo_name (push failed)")
            fi
        else
            echo -e "  ${YELLOW}COMMIT FAILED${NC} (nothing to commit or error)"
            ((failed++))
            failed_repos+=("$repo_name (commit failed)")
        fi
    fi
done

# Final Report
echo ""
echo "=============================================="
echo "SYNC COMPLETE"
echo "=============================================="
echo ""
echo "Summary:"
echo "  Total simple_* repos scanned: $total"
echo "  Repos with changes: $with_changes"
echo "  Successfully pushed: $pushed"
echo "  Failed: $failed"
echo "  No changes: ${#no_changes_repos[@]}"
echo ""

if [ ${#pushed_repos[@]} -gt 0 ]; then
    echo -e "${GREEN}Pushed:${NC}"
    for repo in "${pushed_repos[@]}"; do
        echo "  - $repo"
    done
    echo ""
fi

if [ ${#failed_repos[@]} -gt 0 ]; then
    echo -e "${RED}Failed:${NC}"
    for repo in "${failed_repos[@]}"; do
        echo "  - $repo"
    done
    echo ""
fi

echo "Finished: $(date '+%Y-%m-%d %H:%M:%S')"
