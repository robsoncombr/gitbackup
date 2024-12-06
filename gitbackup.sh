#!/bin/bash

# Check if the target project folder name is provided
if [ -z "$1" ]; then
    echo "Error: No project folder name provided."
    echo "Usage: ./gitbackup.sh <project_folder_name>"
    exit 1
fi

# Get the project folder name
PROJECT_FOLDER="$1"

# Validate that the folder exists in the current directory
if [ ! -d "$PROJECT_FOLDER" ]; then
    echo "Error: The specified folder '$PROJECT_FOLDER' does not exist in the current directory."
    exit 1
fi

# Define the output file in the script's directory
SCRIPT_DIR="$(dirname "$0")"
OUTPUT_FILE="$SCRIPT_DIR/.gitbackup"

# Cleanup any existing .gitbackup file before creating a new one
if [ -f "$OUTPUT_FILE" ]; then
    rm "$OUTPUT_FILE"
fi

# Initialize or empty the output file
> "$OUTPUT_FILE"

# Step 1: Find all .gitignore files in the project folder, excluding node_modules, and append their contents to the output file
find "$PROJECT_FOLDER" -type d -name "node_modules" -prune -o -type f -name ".gitignore" -print | while read -r gitignore_file; do
    echo "Processing .gitignore: $gitignore_file"
    cat "$gitignore_file" >> "$OUTPUT_FILE"
    echo -e "\n" >> "$OUTPUT_FILE"  # Add a newline for separation
done

# Step 2: Clean up the .gitbackup file
# - Remove comments (lines starting with #)
# - Remove blank lines
# - Remove leading and trailing whitespace from each line
# - Remove entries that are "node_modules" or related to "node_modules/"
# - Remove "**/" from the beginning of lines
# - Remove duplicate lines
awk '
    /^[ \t]*#/ { next }                # Skip comment lines
    /^[ \t]*$/ { next }                # Skip blank lines
    /node_modules/ { next }            # Skip node_modules entries
    { gsub(/^[ \t]+|[ \t]+$/, ""); }   # Trim leading and trailing whitespace
    { sub(/^\*\*\//, ""); }            # Remove "**/" from the start of lines
    !seen[$0]++                        # Remove duplicate lines
' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" && mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

# Step 3: Process `.env*` patterns from .gitignore and find matching files
echo "Processing .env* entries from .gitignore..."
TEMP_ENV_FILE="${OUTPUT_FILE}.env_temp"
grep -E '^\.env' "$OUTPUT_FILE" > "$TEMP_ENV_FILE" # Extract .env patterns
grep -vE '^\.env' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" && mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE" # Remove .env patterns from main file

while read -r env_pattern; do
    echo "Searching for files matching pattern: $env_pattern"
    find "$PROJECT_FOLDER" -type f -name "$env_pattern" | while read -r env_file; do
        # Ensure paths are relative to the project folder
        relative_path=$(realpath --relative-to="$PROJECT_FOLDER" "$env_file")
        echo "$relative_path" >> "$OUTPUT_FILE"
    done
done < "$TEMP_ENV_FILE"
rm "$TEMP_ENV_FILE" # Cleanup temporary file

# Step 4: Prefix all entries in the .gitbackup file with the project folder name, avoiding duplicates
echo "Prefixing all entries with the project folder name..."
PROJECT_NAME=$(basename "$PROJECT_FOLDER")
awk -v prefix="$PROJECT_NAME/" '
    $0 !~ /^'"$PROJECT_NAME"'\// { print prefix $0 }  # Add prefix if not already present
    $0 ~ /^'"$PROJECT_NAME"'\// { print $0 }          # Keep entries with correct prefix
' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" && mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

echo "Concatenation, cleanup, .env paths addition, and prefixing complete. Backup created at: $OUTPUT_FILE"
