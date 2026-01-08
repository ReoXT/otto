#!/bin/bash
# Safe file edit script for Claude Code
# This script provides atomic file editing to prevent race conditions

FILE_PATH="$1"
OLD_CONTENT="$2"
NEW_CONTENT="$3"

if [ -z "$FILE_PATH" ] || [ -z "$OLD_CONTENT" ] || [ -z "$NEW_CONTENT" ]; then
  echo "Usage: safe_edit.sh <file_path> <old_content> <new_content>"
  exit 1
fi

# Create a lock file
LOCK_FILE="${FILE_PATH}.lock"
exec 200>"$LOCK_FILE"

# Acquire exclusive lock with timeout (10 seconds)
if ! flock -w 10 -x 200; then
  echo "Error: Could not acquire lock on $FILE_PATH"
  exit 1
fi

# Read current content
CURRENT_CONTENT=$(cat "$FILE_PATH")

# Check if current content matches expected old content
if [ "$CURRENT_CONTENT" != "$OLD_CONTENT" ]; then
  echo "Error: File has been modified since last read"
  flock -u 200
  rm -f "$LOCK_FILE"
  exit 2
fi

# Write new content
echo "$NEW_CONTENT" > "$FILE_PATH"

# Release lock
flock -u 200
rm -f "$LOCK_FILE"

echo "Successfully edited $FILE_PATH"
exit 0
