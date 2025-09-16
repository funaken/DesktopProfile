#!/bin/bash

# git-cleanup-merged-branches.sh
# Lists all merged branches and offers to delete them all at once
# Usage: ./git-cleanup-merged-branches.sh [options]

set -e  # Exit on error

# Function to display help
show_help() {
  echo "Usage: $0 [options]"
  echo "Lists all branches and their merge status, then offers to delete merged branches."
  echo ""
  echo "Options:"
  echo "  -h, --help      Display this help information"
  echo ""
  echo "Output explanation:"
  echo "  - BRANCH NAME:    Name of the merged branch"
  echo "  - COMMIT COUNT:   Number of commits in the branch not in current branch's history"
  echo "  - UNIQUE CONTENT: Number of commits with unique changes not in current branch"
  echo "  - CONTENT STATUS: Whether branch content is already in current branch"
  echo ""
  echo "Example:"
  echo "  $0              # List all branches with merge status and ask for confirmation to delete merged ones"
  exit 0
}

# Function to check if we're in a git repository
check_git_repo() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not in a git repository. Please run this script from within a git repository."
    exit 1
  fi
}

# Function to check if a branch is fully merged using git cherry
is_branch_merged() {
  local branch_name=$1
  local current_branch=$2

  # Use git cherry to check if all commits in branch_name are in current_branch
  local cherry_output=$(git cherry "$current_branch" "$branch_name")

  # If cherry output is empty or only contains lines starting with "-",
  # then all commits are already in the current branch
  if [ -z "$cherry_output" ] || ! echo "$cherry_output" | grep -q "^+"; then
    return 0  # Branch is fully merged
  else
    return 1  # Branch is not fully merged
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
  done

  # Check if we're in a git repository
  check_git_repo

  # Get current branch
  local current_branch=$(git branch --show-current)

  echo "Listing all branches and their merge status with current branch '$current_branch':"
  echo "--------------------------------------------------------------------------------------------"
  printf "%-25s | %-25s | %-25s | %s\n" "BRANCH NAME" "COMMIT COUNT" "UNIQUE CONTENT" "CONTENT STATUS"
  echo "--------------------------------------------------------------------------------------------"

  # Get list of all branches except current branch
  local all_branches=$(git branch | grep -v "^[* ]*$current_branch$" | sed 's/^[ *]*//')

  if [ -z "$all_branches" ]; then
    echo "No other branches found."
    exit 0
  fi

  # Process all branches (both merged and unmerged)
  echo "$all_branches" | while read branch; do
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
      # Should never happen for branches from all_branches, but included for completeness
      content_status="⚠️ Branch appears merged (no commits)"
    elif [ "$unique_commits" -eq 0 ]; then
      content_status="✅ All content already in current branch (MERGED)"
    elif [ "$unique_commits" -lt "$total_commits" ]; then
      content_status="⚠️ Partially in current branch (UNMERGED)"
    else
      content_status="❌ Not in current branch (UNMERGED)"
    fi

    # Print branch info
    printf "%-25s | %-25s | %-25s | %s\n" "$branch" "$total_commits commits" "$unique_commits commits" "$content_status"
  done

  # Store merged branches in a temp file to access outside the subshell
  echo "$all_branches" | while read branch; do
    if [ -z "$branch" ]; then
      continue
    fi
    if is_branch_merged "$branch" "$current_branch"; then
      echo "$branch"
    fi
  done > /tmp/merged-branches-$$

  # Read merged branches from temp file
  if [ ! -s /tmp/merged-branches-$$ ]; then
    echo "No merged branches found."
    rm -f /tmp/merged-branches-$$
    exit 0
  fi

  merged_branches=$(cat /tmp/merged-branches-$$)
  local branch_count=$(echo "$merged_branches" | wc -l | tr -d '[:space:]')

  echo ""
  echo "Found $branch_count merged branch(es) that can be safely deleted."
  echo "Note: Only merged branches (marked with 'MERGED') will be deleted."


  # Ask for confirmation
  echo ""
  read -p "Delete all these merged branches? (Yes/y or No/n): " confirm
  if [[ "$confirm" != "Yes" && "$confirm" != "y" ]]; then
    echo "Branch deletion cancelled."
    rm -f /tmp/merged-branches-$$
    exit 0
  fi

  # Delete all merged branches
  echo "Deleting merged branches..."
  local deleted_count=0

  echo "$merged_branches" | while read branch; do
    if [ -n "$branch" ]; then
      echo "  Deleting branch: $branch"
      git branch -D "$branch"
      deleted_count=$((deleted_count + 1))
    fi
  done

  echo "Successfully deleted $branch_count merged branch(es)."
  rm -f /tmp/merged-branches-$$
}

# Execute main function
main "$@"