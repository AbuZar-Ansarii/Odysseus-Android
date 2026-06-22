#!/data/data/com.termux/files/usr/bin/bash

# Termux + proot-distro Ubuntu Installer for Odysseus
# This script automates the full installation of Odysseus inside Ubuntu PRoot.
# Designed for a one-line install:
# curl -sSL https://raw.githubusercontent.com/AbuZar-Ansarii/Odysseus-Android/main/install.sh | bash

# Exit immediately if a command exits with a non-zero status
set -e

# Disable interactive prompts in apt/dpkg
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

echo "=========================================================="
echo " Starting Odysseus Termux Installer (Non-Interactive) "
echo "=========================================================="

# 1. Update and upgrade Termux packages automatically
echo "[1/4] Updating Termux packages..."
# Using yes and force-confold to bypass any prompts during upgrade
yes | apt-get update -y
yes | apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# 2. Install Git and proot-distro in Termux
echo "[2/4] Installing Git and proot-distro..."
yes | apt-get install -y -o Dpkg::Options::="--force-confold" git proot-distro

# 3. Check and install Ubuntu PRoot if not present
echo "[3/4] Setting up Ubuntu PRoot environment..."
if ! proot-distro list | grep -q "ubuntu (installed)"; then
    echo "Installing Ubuntu inside proot-distro (this may take a few minutes)..."
    proot-distro install ubuntu
else
    echo "Ubuntu is already installed in proot-distro."
fi

# 4. Set up and install Odysseus inside the Ubuntu container
echo "[4/4] Configuring Odysseus inside the Ubuntu environment..."

# We execute a set of automated setup commands inside the Ubuntu container.
# All Ubuntu apt commands are configured to automatically accept defaults.
proot-distro login ubuntu -- bash -c '
    set -e
    export DEBIAN_FRONTEND=noninteractive
    export APT_LISTCHANGES_FRONTEND=none

    echo "--- [Ubuntu] Updating package manager lists ---"
    yes | apt-get update -y
    yes | apt-get upgrade -y -o Dpkg::Options::="--force-confold"

    echo "--- [Ubuntu] Installing Python, Git, compilation tools, and Rust ---"
    # rustc and cargo are required for compiling cryptography and pydantic on aarch64
    yes | apt-get install -y -o Dpkg::Options::="--force-confold" \
        git python3 python3-pip python3-venv build-essential \
        libssl-dev libffi-dev python3-dev rustc cargo curl

    echo "--- [Ubuntu] Cloning Odysseus Repository ---"
    if [ -d "odysseus" ]; then
        echo "Odysseus directory already exists. Pulling latest code..."
        cd odysseus
        git pull
    else
        git clone https://github.com/pewdiepie-archdaemon/odysseus.git
        cd odysseus
    fi

    echo "--- [Ubuntu] Setting up Python Virtual Environment ---"
    python3 -m venv venv
    source venv/bin/activate

    echo "--- [Ubuntu] Upgrading pip, setuptools, and wheel ---"
    pip install --upgrade pip setuptools wheel --no-input

    echo "--- [Ubuntu] Installing Python requirements (This will take a while) ---"
    pip install -r requirements.txt --no-input

    echo "--- [Ubuntu] Initializing Odysseus Database ---"
    export ODYSSEUS_ADMIN_PASSWORD="71807180"
    python3 setup.py

    echo ""
    echo "=========================================================="
    echo " Odysseus Installation Completed Successfully!"
    echo "=========================================================="
    echo "Default Login Credentials:"
    echo "  Username: admin"
    echo "  Password: 71807180"
    echo "=========================================================="
'

# Create startup script in Termux home directory
echo "Creating run.sh startup script in Termux Home..."
cat << 'EOF' > $HOME/run.sh
#!/data/data/com.termux/files/usr/bin/bash
proot-distro login ubuntu -- bash -c "cd odysseus && source venv/bin/activate && python3 -m uvicorn app:app --host 0.0.0.0 --port 7000"
EOF
chmod +x $HOME/run.sh

echo ""
echo "=========================================================="
echo " You can now start Odysseus anytime in Termux by running:"
echo "   ./run.sh"
echo "=========================================================="
