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

if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.profile" 2>/dev/null; then
  echo "Adding ~/bin to PATH in ~/.profile ..."
  printf '\n# Add user bin to PATH\nexport PATH="$HOME/bin:$PATH"\n' >> "$HOME/.profile"
fi

export PATH="$HOME/bin:$PATH"


# Step 7.2: Create wrapper script
cat > "$HOME/bin/mango" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# --- Dynamically locate the project directory ---
# This script assumes that the setup.sh file was run from within the project folder.
# So we store the real path of this script during setup and reuse it here.

PROJECT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# The above line resolves to ~/bin, so we fix it to the actual project dir stored during setup.
PROJECT_DIR_PLACEHOLDER="__PROJECT_DIR__"
PROJECT_DIR="$PROJECT_DIR_PLACEHOLDER"

SCRIPT="$PROJECT_DIR/mangoboy.sh"

if [[ ! -f "$SCRIPT" ]]; then
  echo "ERROR: $SCRIPT not found in $PROJECT_DIR" >&2
  exit 1
fi

cd "$PROJECT_DIR"
exec bash "$SCRIPT" "$@"
EOF

# Replace placeholder with the actual project path
PROJECT_PATH="$(pwd)"
sed -i "s|__PROJECT_DIR__|$PROJECT_PATH|g" "$HOME/bin/mango"

chmod +x "$HOME/bin/mango"
hash -r


echo "'mango' command installed successfully!"
echo "You can now type 'mango' in any terminal to run the main script."
echo "   (Restart your terminal if not recognized yet.)"

echo
echo "Setup complete!"
echo "To start manually, run: ./mangoboy.sh"
echo "To activate the Python environment later: source venv/bin/activate"
