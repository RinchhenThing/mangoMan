#!/usr/bin/env bash
set -euo pipefail

echo "Setting up environment for SSH Server project..."

# --- Step 1: Install dependencies ---
echo "Installing required packages..."
sudo apt update -y
sudo apt install -y bash openssh-client python3 python3-venv

# --- Step 2: Navigate to script directory ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# --- Step 3: Fix permissions ---
echo "🔧 Setting proper file permissions..."
[[ -f key ]] && chmod 600 key
chmod +x mangoboy.sh run-remote.sh 2>/dev/null || true

# --- Step 4: Setup and activate virtual environment ---
if [[ ! -d "venv" ]]; then
  echo "Creating virtual environment..."
  python3 -m venv venv
fi

echo "Activating virtual environment..."
source venv/bin/activate

# --- Step 5: Install Paramiko if missing ---
if ! python3 -c "import paramiko" &>/dev/null; then
  echo "Installing Paramiko..."
  pip install --upgrade pip
  pip install paramiko
else
  echo "Paramiko already installed."
fi

# --- Step 6: Run setup scripts ---
for script in bashes/ask_credentials.sh bashes/custom_commands.sh bashes/write_key.sh; do
  if [[ "$script" ]]; then
    bash "$script"
  else
    echo "kipping missing script: $script"
  fi
done

echo
echo "Setup complete!"
echo "o start, run: ./mangoboy.sh"
echo "To activate the Python environment later: source venv/bin/activate"
