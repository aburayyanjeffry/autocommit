#!/bin/bash
NAME=autocommit
EMAIL="$USER@$(hostname)"
GIT_HOME=/Users/kaptenjeffry/workspace/etc

# Set environment variables for Git author and committer
export GIT_AUTHOR_NAME="$NAME"
export GIT_AUTHOR_EMAIL="$EMAIL"
export GIT_COMMITTER_NAME="$NAME"
export GIT_COMMITTER_EMAIL="$EMAIL"

# Change to GIT_HOME directory
cd $GIT_HOME
pwd

# Check if the current directory is inside a Git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Not in a Git repository. Exiting."
    exit 1  # Exit with an error code (1) to indicate failure
fi

# Check if .gitautocommit exist
if [ ! -e ".gitautocommit" ]; then
    echo ".gitautocommit does not exist"
    exit 1  # Exit with an error code (1) if the file does not exist
fi

# Check if at least one file is modified
modified_files=""
while IFS= read -r file; do
    if git status --porcelain "$file" | grep $file; then
        modified_files="$modified_files $file"
    fi
done < .gitautocommit

# Commit if there are modified files
if [ -n "$modified_files" ]; then
    git add $modified_files
    git commit -m "Auto-commit: Updated $modified_files"
    echo "Changes committed."
else
    echo "No changes to commit."
fi
