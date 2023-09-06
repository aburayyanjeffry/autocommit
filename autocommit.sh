#!/bin/bash
# Author: Jeffry Johar
# Date: 6th Sept. 2023
# About: To auto commit files in a git respository
# Name : autocommit.sh
# Crontab: 0 * * * * # every hour

# Global Variable
NAME=autocommit
EMAIL="$USER@$(hostname)"
GIT_HOME=""

# Set environment variables for Git author and committer
export GIT_AUTHOR_NAME="$NAME"
export GIT_AUTHOR_EMAIL="$EMAIL"
export GIT_COMMITTER_NAME="$NAME"
export GIT_COMMITTER_EMAIL="$EMAIL"

# Change to GIT_HOME directory
if [ -z "$GIT_HOME" ]; then
   cd "$(dirname "$0")"
   echo "current directory" 
else
    cd $GIT_HOME
    echo "git home has value"
fi

# Check if git command is available
if ! command -v git &> /dev/null; then
    echo "Git is not installed on your system. Exiting..."
    exit 1
fi

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
    git commit -m "autocommit: Updated $modified_files"
    echo "Changes committed."
else
    echo "No changes to commit."
fi
