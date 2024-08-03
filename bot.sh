#!/usr/bin/env bash

# Define the repository URL and directory
REPO_URL="https://github.com/LukaNikolaisvili/github_bot.git"
REPO_DIR="/var/jenkins_home/workspace/test/github_bot"

# Ensure the repository directory is safe for Git
git config --global --add safe.directory $REPO_DIR

# Check if the repository directory exists
if [ ! -d "$REPO_DIR" ]; then
  echo "Cloning repository..."
  git clone $REPO_URL $REPO_DIR
else
  echo "Repository already exists. Pulling latest changes..."
  cd $REPO_DIR || exit 1
  git pull
fi

# Navigate to the repository directory
cd $REPO_DIR || { echo "Failed to change directory to $REPO_DIR"; exit 1; }

# Fix permissions to ensure Jenkins user can write to the directory
# Generate commit information
info="Commit: $(date)"
echo "$info" >> output.txt || { echo "Failed to write to output.txt"; exit 1; }
echo "$info"
echo

# Set up Git to use the public repository URL
git remote set-url origin $REPO_URL

# Configure Git to handle divergent branches by merging
git config pull.rebase false

# Pull the latest changes
git pull

# Function to execute a shell command and check for errors
execute_command() {
    command=$1
    eval $command
    if [ $? -ne 0 ]; then
        echo "Command failed: $command"
        exit 1
    fi
}

# Iterate over each day in the past year
for i in $(seq 1 365); do
    # Generate a random number of commits for each day
    for j in $(seq 0 $((RANDOM % 10 + 1))); do
        # Calculate the date for the commit
        commit_date=$(date -d "$i days ago" '+%Y-%m-%d %H:%M:%S')

        # Write the commit date to the file
        echo "Commit on $commit_date" >> file.txt

        # Add the changes to the staging area
        execute_command 'git add file.txt'

        # Commit the changes with the specified date
        execute_command "git commit --date=\"$commit_date\" -m \"commit\""
    done
done

# Push the changes to the remote repository
execute_command 'git push -u origin main'
