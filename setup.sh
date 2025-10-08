#!/usr/bin/env bash
set -euo pipefail

echo "Setting up environment for SSH Server project..."

# --- Step 1: Install dependencies ---
echo "Installing required packages..."
sudo apt update -y
sudo apt install -y bash openssh-client python3 python3-venv python3-pip

# --- Step 2: Navigate to script directory ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# --- Step 3: Fix permissions ---
echo "Setting proper file permissions..."
[[ -f key ]] && chmod 600 key
chmod +x mangoboy.sh run-remote.sh 2>/dev/null || true

# --- Step 4: Setup and activate virtual environment ---
if [[ ! -d "venv" ]]; then
  echo "Creating virtual environment..."
  python3 -m venv venv
fi

echo "Activating virtual environment..."
# shellcheck source=/dev/null
source venv/bin/activate

# --- Step 5: Install Paramiko if missing ---
if ! python3 -c "import paramiko" &>/dev/null; then
  echo "Installing Paramiko..."
  pip install --upgrade pip
  pip install paramiko
else
  echo "Paramiko already installed."
fi

# --- Step 6: Run setup scripts (if present) ---
for script in bashes/ask_credentials.sh bashes/custom_commands.sh bashes/write_key.sh; do
  if [[ -f "$script" ]]; then
    echo "Running $script ..."
    bash "$script"
  else
    echo "Skipping missing script: $script"
  fi
done


# --- Step 7: Create global 'mango' command ---
echo
echo "Installing 'mango' command for quick access..."

# Step 7.1: Create ~/bin if missing and ensure it's in PATH
mkdir -p "$HOME/bin"

# Ensure ~/bin is in PATH in .profile and .bashrc
for rcfile in "$HOME/.profile" "$HOME/.bashrc"; do
  if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$rcfile" 2>/dev/null; then
    echo "Adding ~/bin to PATH in $rcfile ..."
    printf '\n# Add user bin to PATH\nexport PATH="$HOME/bin:$PATH"\n' >> "$rcfile"
  fi
done

# Apply it immediately for this session
export PATH="$HOME/bin:$PATH"

# Step 7.2: Detect where mangoboy.sh actually is
if [[ -f "$SCRIPT_DIR/project/mangoboy.sh" ]]; then
  MAIN_SCRIPT_PATH="$SCRIPT_DIR/project/mangoboy.sh"
elif [[ -f "$SCRIPT_DIR/mangoboy.sh" ]]; then
  MAIN_SCRIPT_PATH="$SCRIPT_DIR/mangoboy.sh"
else
  echo "ERROR: Could not locate mangoboy.sh in project directory." >&2
  exit 1
fi

# Step 7.3: Create the mango launcher
cat > "$HOME/bin/mango" <<EOF
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_PATH="$MAIN_SCRIPT_PATH"
cd "\$(dirname "\$SCRIPT_PATH")"
exec bash "\$SCRIPT_PATH" "\$@"
EOF

chmod +x "$HOME/bin/mango"
hash -r

echo "'mango' command installed successfully!"
echo "You can now type 'mango' in any terminal to run the main script."
echo "   (No restart needed!)"

echo
echo "Setup complete!"
echo "To start manually, run: ./mangoboy.sh"
echo "To activate the Python environment later: source venv/bin/activate"
