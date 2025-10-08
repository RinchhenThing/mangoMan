#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY_PATH="${SCRIPT_DIR}/key"
CRED_FILE="${SCRIPT_DIR}/credentials.txt"
CMD_FILE="${SCRIPT_DIR}/commands.txt"

# --- Read credentials ---
if [[ ! -f "$CRED_FILE" ]]; then
  echo "❌ ERROR: credentials.txt not found!"
  exit 1
fi

HOST=$(grep -E '^host=' "$CRED_FILE" | cut -d'=' -f2- | tr -d '[:space:]')
USER=$(grep -E '^user=' "$CRED_FILE" | cut -d'=' -f2- | tr -d '[:space:]')

if [[ -z "$HOST" || -z "$USER" ]]; then
  echo "❌ ERROR: Invalid credentials.txt format!"
  echo "Example:"
  echo "host=1.2.3.4"
  echo "user=root"
  exit 1
fi

[[ -f "$KEY_PATH" ]] || { echo "❌ Key not found at $KEY_PATH"; exit 1; }
[[ -f "$CMD_FILE" ]] || { echo "❌ Commands file not found at $CMD_FILE"; exit 1; }

chmod 600 "$KEY_PATH" || true

echo "🔑 Using key: $KEY_PATH"
echo "🌐 Connecting to $USER@$HOST ..."
echo
echo "📜 Reading commands from $CMD_FILE"
echo "-----------------------------------"

# --- Read commands into a variable ---
COMMANDS=$(grep -vE '^\s*#' "$CMD_FILE" | sed '/^\s*$/d')

# --- Run all commands in a single SSH session ---
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=accept-new "$USER@$HOST" "bash -s" <<EOF
set -e
echo "🚀 Executing commands on remote host..."
echo "-----------------------------------"
$COMMANDS
echo "-----------------------------------"
echo "✅ Remote execution finished."
EOF

echo
echo "✅ All commands executed successfully."
