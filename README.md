# 📱Odysseus AI - Android Installation (Termux)

#### Run a private, self-hosted AI workspace on your Android device using proot-distro Ubuntu

This guide explains how to install and run **Odysseus** (the self-hosted AI workspace by PewDiePie/pewdiepie-archdaemon) on your Android device using **Termux** and **PRoot Distro (Ubuntu)**.

We provide two installation methods:
1. **One-Line Automated Installation** (Recommended)
2. **Manual Step-by-Step Installation**

---

## Prerequisites

1. **Android Device**: A relatively modern phone with at least 4GB of RAM (8GB+ recommended).
2. **Termux (F-Droid version)**: Do **NOT** install Termux from the Google Play Store, as that version is deprecated and no longer receives package updates. Download it from [F-Droid](https://f-droid.org/packages/com.termux/).
3. **Free Storage**: At least 4-6GB of free storage space.
4. **Internet Connection**: A stable connection for downloading packages and cloning dependencies.

---

## Method 1: One-Line Automated Installation

This method automatically updates Termux, installs `proot-distro`, sets up Ubuntu, configures all packages, compiles Python dependencies (handling all `y/n` prompts automatically), and runs the initial setup.

Open your Termux app and run the following command:

```bash
curl -sSL https://raw.githubusercontent.com/AbuZar-Ansarii/Odysseus-Android/main/install.sh | bash
```

Once the installation finishes, you can start the Odysseus server by running:
```bash
./run.sh
```

Log in using the following default credentials:
* **Username:** `admin`
* **Password:** `71807180`

---

## Method 2: Manual Step-by-Step Installation

If you prefer to run the setup steps manually, follow these instructions:

### Step 1: Install Termux & Set Up Base Packages
Open Termux and run:
```bash
# Update and upgrade Termux packages
pkg update && pkg upgrade -y

# Install git, curl, and proot-distro
pkg install git curl proot-distro -y
```

### Step 2: Install and Log into Ubuntu
```bash
# Install Ubuntu distro
proot-distro install ubuntu

# Log in to your new Ubuntu environment
proot-distro login ubuntu
```

### Step 3: Install Required Linux Dependencies (Inside Ubuntu)
Inside the Ubuntu terminal, run:
```bash
# Update Ubuntu packages
apt update && apt upgrade -y

# Install build dependencies, Python, and Rust/Cargo (needed for cryptography/pydantic compilation)
apt install -y git python3 python3-pip python3-venv build-essential libssl-dev libffi-dev python3-dev rustc cargo curl
```

### Step 4: Clone the Odysseus Repository
```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus
```

### Step 5: Set Up the Python Virtual Environment
```bash
# Create a virtual environment named 'venv'
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Upgrade pip, setuptools, and wheel for clean installation
pip install --upgrade pip setuptools wheel
```

### Step 6: Install Python Dependencies
```bash
pip install -r requirements.txt
```
> [!IMPORTANT]
> Because compilation is happening on your mobile device inside an emulated Linux environment, compiling packages like `cryptography`, `greenlet`, or `pydantic-core` can take **10 to 30 minutes** depending on your phone's processor. Please be patient.

### Step 7: Run Odysseus Initialization
If you want to set your password to the default (`71807180`), run:
```bash
export ODYSSEUS_ADMIN_PASSWORD="71807180"
python3 setup.py
```
Otherwise, simply run `python3 setup.py` and it will generate a random temporary password for you (make sure to copy it!).

---

## How to Start Odysseus in the Future

You can start the Odysseus server at any time by running the `run.sh` script included in this repository:

```bash
chmod +x run.sh
./run.sh
```

Alternatively, you can run the start command directly:

```bash
proot-distro login ubuntu -- bash -c "cd odysseus && source venv/bin/activate && python3 -m uvicorn app:app --host 0.0.0.0 --port 7000"
```

Once the server is running, open your phone's web browser and go to `http://localhost:7000`. Log in using:
* **Username:** `admin`
* **Password:** `71807180` (or your custom password)
