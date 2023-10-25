#!/bin/bash
# Author: Jeffry Johar
# Date: 6th Sept. 2023
# About: To auto commit files in a git respository
# Name : autocommit.sh
# Crontab: 0 * * * * # every hour

# Global Variable
if [ -z $GIT_AUTOCOMMIT_NAME ]; then
    GIT_AUTOCOMMIT_NAME=autocommit
fi
if [ -z $GIT_AUTOCOMMIT_EMAIL ]; then
    GIT_AUTOCOMMIT_EMAIL="autocommit@$(hostname)"
fi

# Set environment variables for Git author and committer
if [ -z $GIT_AUTHOR_NAME ]; then
    export GIT_AUTHOR_NAME="$GIT_AUTOCOMMIT_NAME"
fi
if [ -z $GIT_AUTHOR_EMAIL ]; then
    export GIT_AUTHOR_EMAIL="$GIT_AUTOCOMMIT_EMAIL"
fi
if [ -z $GIT_COMMITTER_NAME ]; then
    export GIT_COMMITTER_NAME="$GIT_AUTOCOMMIT_NAME"
fi
if [ -z $GIT_COMMITTER_EMAIL ]; then
    export GIT_COMMITTER_EMAIL="$GIT_AUTOCOMMIT_EMAIL"
fi

# Change to GIT_HOME directory
GIT_HOME="$1"
if [ -z "$GIT_HOME" ]; then
   cd "$(dirname "$0")"
   #echo "current directory" 
else
    cd "$GIT_HOME" || { echo "Could not cd to $GIT_HOME" >&2; exit 1; }
    #echo "git home has value"
fi

# Check if git command is available
if ! command -v git &> /dev/null; then
    echo "Git is not installed on your system. Exiting..." >&2
    exit 1
fi

# Check if the current directory is inside a Git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Not in a Git repository. Exiting." >&2
    exit 1  # Exit with an error code (1) to indicate failure
fi

# Check if .gitautocommit exist
if [ ! -e ".gitautocommit" ]; then
    echo ".gitautocommit does not exist" >&2
    exit 1  # Exit with an error code (1) if the file does not exist
fi

# Read the .gitautocommit file line by line
while IFS= read -r file; do
    # Check if the file is a directory pattern
    if [[ "$file" == */* ]]; then
        # Use 'find' to list all files within the specified directory and subdirectories
        files_in_directory=$(find $file -type f)
        # Loop through the files and check their status
        for subfile in $files_in_directory; do
            if git status --porcelain "$subfile" | grep "$subfile"; then
                modified_files="$modified_files $subfile"
            fi
        done
    else
        # Check the status of the single file
        if git status --porcelain "$file" | grep "$file"; then
            modified_files="$modified_files $file"
        fi
    fi
done < .gitautocommit

# Commit if there are modified files
if [ -n "$modified_files" ]; then
    git add $modified_files
    git commit -m "autocommit: Updated $modified_files"
    echo "Changes committed."
else
    exit 0
    # echo "No changes to commit."
fi
