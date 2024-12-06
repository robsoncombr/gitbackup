#!/bin/bash

# Define the main directory
MAIN_DIR="repomodel"

# Create the main directory
mkdir -p "$MAIN_DIR"

# Initialize a Git repository in the main directory
cd "$MAIN_DIR" || exit
#git init > /dev/null

# Define subdirectories and files
SUBDIRS=("config" "src" "assets" "docs" "dist" "devops/scripts")
FILES=("README.md" "LICENSE" ".env.example" ".env" "main.py" "devops/.env" "devops/scripts/run.sh" "devops/scripts/deploy.sh")

# Create subdirectories with a .gitkeep file inside each
for DIR in "${SUBDIRS[@]}"; do
  mkdir -p "$DIR"
  touch "$DIR/.gitkeep"
done

# Create files in the main directory
for FILE in "${FILES[@]}"; do
  touch "$FILE"
done

# Create a .gitignore file with some lines
cat <<EOL > .gitignore
.env
dist/
EOL

# Create a .gitignore file with some lines
cat <<EOL > devops/.gitignore
.env
scripts/deploy.sh
EOL

# Print success message
echo "Repository 'repomodel' created successfully!"
echo "Run ./gitbackup.sh ./repomodel to simulate and test"
