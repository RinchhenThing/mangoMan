#!/bin/bash
set -euo pipefail

echo -e "\n"

# Ask for IP
read -p "Enter the host IP: " IP

# Ask for username
read -p "Enter the user name: " user

# Get the absolute path of the project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CREDENTIALS_FILE="$SCRIPT_DIR/secrets_and_variables/credentials.txt"

# Ensure directory exists
mkdir -p "$(dirname "$CREDENTIALS_FILE")"

# Write to file with newline properly
echo -e "host=$IP\nuser=$user" > "$CREDENTIALS_FILE"

echo "✅ Credentials saved to: $CREDENTIALS_FILE"

