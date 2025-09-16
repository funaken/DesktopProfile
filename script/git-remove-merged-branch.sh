#!/bin/bash

# git-remove-merged-branch.sh
# A script to check if a branch is fully merged using git cherry and delete it (always force delete)
# Usage: ./git-remove-merged-branch.sh [options] <branch_name>

set -e  # Exit on error

# Function to display help
show_help() {
  echo "Usage: $0 [options] <branch_name>"
  echo "Check if a branch is fully merged into the current branch and delete it (always force delete)."
  echo ""
  echo "Options:"
  echo "  -f, --force     Force delete merged branch without confirmation"
  echo "  -q, --quiet     Suppress all output messages"
  echo "  -h, --help      Display this help information"
  echo "  -dryrun         Show what would happen without actually deleting"
  echo ""
  echo "Example:"
  echo "  $0 feature/login        # Check and interactively delete feature/login branch"
  echo "  $0 --force bugfix/issue-123 # Delete bugfix/issue-123 branch without confirmation (only if merged)"
  echo "  $0 -dryrun feature/xyz  # Check if branch can be deleted without actually deleting"
  exit 0
}

# Function to check if we're in a git repository
check_git_repo() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    [ "$quiet" != true ] && echo "Error: Not in a git repository. Please run this script from within a git repository."
    exit 1
  fi
}

# Function to check if a branch exists
check_branch_exists() {
  local branch_name=$1
  if ! git rev-parse --verify --quiet "refs/heads/$branch_name" > /dev/null; then
    [ "$quiet" != true ] && echo "Error: Branch '$branch_name' does not exist."
    exit 1
  fi
}

# Function to check if a branch is fully merged using git cherry
is_branch_merged() {
  local branch_name=$1
  local current_branch=$(git branch --show-current)
  
  # Use git cherry to check if all commits in branch_name are in current_branch
  local cherry_output=$(git cherry "$current_branch" "$branch_name")
  
  # If cherry output is empty or only contains lines starting with "-",
  # then all commits are already in the current branch
  if [ -z "$cherry_output" ] || ! echo "$cherry_output" | grep -q "^+"; then
    return 0  # Branch is fully merged
  else
    # Store the cherry output for later use
    echo "$cherry_output" > /tmp/git-cherry-output-$$
    return 1  # Branch is not fully merged
  fi
}

# Main execution
main() {
  # Parse command line arguments
  local force=false
  local dryrun=false
  local quiet=false
  local branch_name=""
  
  while [ $# -gt 0 ]; do
    case "$1" in
      -h|--help)
        show_help
        ;;
      -f|--force)
        force=true
        shift
        ;;
      -q|--quiet)
        quiet=true
        shift
        ;;
      -dryrun|--dryrun)
        dryrun=true
        shift
        ;;
      -*)
        [ "$quiet" != true ] && echo "Error: Unknown option: $1"
        [ "$quiet" != true ] && echo "Use --help for usage information."
        exit 1
        ;;
      *)
        # If it's not an option, it's the branch name
        branch_name="$1"
        shift
        ;;
    esac
  done
  
  # Check if branch name was provided
  if [ -z "$branch_name" ]; then
    [ "$quiet" != true ] && echo "Error: No branch name specified."
    [ "$quiet" != true ] && echo "Use --help for usage information."
    exit 1
  fi
  
  # Check if we're in a git repository
  check_git_repo
  
  # Check if the specified branch exists
  check_branch_exists "$branch_name"
  
  # Get current branch
  local current_branch=$(git branch --show-current)
  
  # Check if trying to delete the current branch
  if [ "$branch_name" = "$current_branch" ]; then
    [ "$quiet" != true ] && echo "Error: Cannot delete the current branch '$current_branch'."
    [ "$quiet" != true ] && echo "Please switch to another branch first."
    exit 1
  fi
  
  [ "$quiet" != true ] && echo "Checking if branch '$branch_name' is fully merged into current branch '$current_branch'..."
  
  # Check if the branch is fully merged
  local is_merged=false
  if is_branch_merged "$branch_name"; then
    [ "$quiet" != true ] && echo "✅ Branch '$branch_name' is fully merged into current branch '$current_branch'."
    is_merged=true
  else
    [ "$quiet" != true ] && echo "❌ Branch '$branch_name' is NOT fully merged into current branch '$current_branch'."

    # Display the commits that are not merged
    if [ -f /tmp/git-cherry-output-$ ] && [ "$quiet" != true ]; then
      echo "The following commits in '$branch_name' are not in '$current_branch':"
      cat /tmp/git-cherry-output-$ | grep "^+" | cut -c 3- | while read commit; do
        git log -1 --pretty=format:"  %h - %s (%an)" "$commit"
        echo
      done
    fi
    [ -f /tmp/git-cherry-output-$ ] && rm -f /tmp/git-cherry-output-$

    [ "$quiet" != true ] && echo "Error: Cannot force delete unmerged branch '$branch_name'."
    exit 1
  fi
  
  # Handle dry run
  if [ "$dryrun" = true ]; then
    if [ "$quiet" != true ]; then
      if [ "$is_merged" = true ]; then
        echo "Dry run mode: Would run command: git branch -d $branch_name"
      else
        echo "Dry run mode: Would run command: git branch -D $branch_name (force delete)"
      fi
      echo "This would delete the branch '$branch_name' from your local repository."
    fi
    exit 0
  fi
  
  # Ask for confirmation unless force is specified
  if [ "$force" = false ]; then
    read -p "Delete branch '$branch_name'? (Yes/y or No/n): " confirm
    if [[ "$confirm" == "Yes" || "$confirm" == "y" ]]; then
      # Continue to deletion (outside this if block)
      :
    else
      echo "Branch deletion cancelled."
      exit 0
    fi
  fi
  
  # Delete the branch (if force=true or user confirmed)
  [ "$quiet" != true ] && echo "Deleting branch '$branch_name'..."
  git branch -D "$branch_name"  # Force delete
  [ "$quiet" != true ] && echo "Branch '$branch_name' has been deleted."
}

# Execute main function
main "$@"