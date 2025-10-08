#!/bin/bash
set -euo pipefail

file_path=../secrets_and_variables/key

echo -e "\n"
echo "Paste your private SSH key. When finished press CTRL+D"
echo "-------------------------------------------------"

# Read multi-line content from stdin
user_input=$(</dev/stdin)

# Basic input check
if [[ -z "${user_input//[$'\t\r\n']}" ]]; then
  echo "No input received. Aborting."
  exit 1
fi


# Ensure target directory exists
dir=$(dirname "$file_path")
mkdir -p "$dir"

# Write atomically to avoid partial writes: write to temp then move
tmpfile=$(mktemp "${dir}/.tmp_secret.XXXXXX")
trap 'rm -f "$tmpfile"' EXIT

# Use printf to preserve exact content (no interpretation)
printf '%s\n' "$user_input" > "$tmpfile"

# Set secure permissions on temp file
chmod 600 "$tmpfile"

# Move temp file to target (atomic on same filesystem)
mv -f "$tmpfile" "$file_path"
trap - EXIT

# Ensure target file has secure perms
chmod 600 "$file_path"

echo "Content written to $file_path (permissions set to 600)."
