#!/bin/bash

# git-list-no-marged-branch.sh
# Lists all branches not merged into the current branch and checks content merge status using git cherry
# Usage: ./git-list-no-marged-branch.sh [options]

set -e  # Exit on error

# Function to display help
show_help() {
  echo "Usage: $0 [options]"
  echo "Lists all branches not merged into the current branch and checks content merge status."
  echo ""
  echo "Options:"
  echo "  -h, --help      Display this help information"
  echo ""
  echo "Output explanation:"
  echo "  - BRANCH NAME:    Name of the unmerged branch"
  echo "  - COMMIT COUNT:   Number of commits in the branch not in current branch's history"
  echo "  - UNIQUE CONTENT: Number of commits with unique changes not in current branch"
  echo "  - CONTENT STATUS: Whether branch content is already in current branch"
  echo ""
  echo "Example:"
  echo "  $0              # List all unmerged branches from current branch"
  exit 0
}

# Function to check if we're in a git repository
check_git_repo() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not in a git repository. Please run this script from within a git repository."
    exit 1
  fi
}

# Main execution
main() {
  # Parse command line arguments
  while [ $# -gt 0 ]; do
    case "$1" in
      -h|--help)
        show_help
        ;;
      *)
        echo "Error: Unknown option: $1"
        echo "Use --help for usage information."
        exit 1
        ;;
    esac
    shift
  done
  
  # Check if we're in a git repository
  check_git_repo
  
  # Get current branch
  local current_branch=$(git branch --show-current)
  
  echo "Listing branches not merged into current branch '$current_branch':"
  echo "--------------------------------------------------------------------------------------------"
  printf "%-25s | %-25s | %-25s | %s\n" "BRANCH NAME" "COMMIT COUNT" "UNIQUE CONTENT" "CONTENT STATUS"
  echo "--------------------------------------------------------------------------------------------"
  
  # Get list of unmerged branches
  local unmerged_branches=$(git branch --no-merged "$current_branch" | sed 's/^[ *]*//')
  
  if [ -z "$unmerged_branches" ]; then
    echo "No unmerged branches found."
    exit 0
  fi
  
  # Check each unmerged branch
  echo "$unmerged_branches" | while read branch; do
    # Skip empty lines
    if [ -z "$branch" ]; then
      continue
    fi
    
    # Count total commits not in current branch
    local total_commits=$(git log "$current_branch..$branch" --oneline | wc -l | tr -d '[:space:]')
    
    # Use git cherry to check unique commits not in current branch
    local cherry_output=$(git cherry "$current_branch" "$branch")
    local unique_commits=$(echo "$cherry_output" | grep -c "^+" || true)
    
    # Determine content status
    if [ "$total_commits" -eq 0 ]; then
      # Should never happen for branches from --no-merged, but included for completeness
      content_status="⚠️ Branch appears merged (no commits)"
    elif [ "$unique_commits" -eq 0 ]; then
      content_status="✅ All content already in current branch"
    elif [ "$unique_commits" -lt "$total_commits" ]; then
      content_status="⚠️ Partially in current branch"
    else
      content_status="❌ Not in current branch"
    fi
    
    # Print branch info
    printf "%-25s | %-25s | %-25s | %s\n" "$branch" "$total_commits commits" "$unique_commits commits" "$content_status"
  done
}

# Execute main function
main "$@"