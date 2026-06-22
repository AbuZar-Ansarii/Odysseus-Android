# 📱 Odysseus AI — Android
### *free, open-source, and self-hosted AI workspace*

---

A professional guide and automation suite to run **Odysseus** (the private, local-first AI workspace by PewDiePie) inside a sandboxed Linux environment on your Android device.

---

## 📋 Features & Overview

| Feature | Description |
| :--- | :--- |
| **Local-First & Private** | Keep your chats, data, and workflows secure on your device. |
| **One-Line Installer** | Installs Ubuntu, sets up python virtualenvs, compiles libraries, and pre-seeds the password automatically. |
| **Custom Quick-Launch** | Start the server in a single command using the generated `./run.sh` script. |
| **Android Optimizations** | Standardized compiling dependencies tailored for `aarch64` architectures inside Termux PRoot. |

---

## ⚙️ Prerequisites

Before you start, please ensure your Android device meets the following requirements:

* **RAM:** At least 4GB of RAM (8GB+ recommended for running local models).
* **Storage:** 4GB to 6GB of free storage space.
* **Termux (F-Droid):** Do **NOT** use the Google Play Store version as it is deprecated. Download the latest release from [F-Droid](https://f-droid.org/packages/com.termux/).
* **Internet:** A stable connection for package installation and repository cloning.

---

## 🚀 Method 1: One-Line Automated Installation (Recommended)

This method automates the entire process (system updates, package installation, repo cloning, dependencies compilation, database setup, and creating the startup shortcut).

Open your Termux terminal and paste:

```bash
curl -sSL https://raw.githubusercontent.com/AbuZar-Ansarii/Odysseus-Android/main/install.sh | bash
```

### 🏁 Starting the Server
Once the installer completes, simply start the Odysseus server by running:
```bash
./run.sh
```

### 🔑 Default Credentials
Use these details to log in to the dashboard at `http://localhost:7000`:
* **Username:** `admin`
* **Password:** `71807180`

---

## 🛠️ Method 2: Manual Step-by-Step Installation

If you prefer to configure everything manually, execute the following steps sequence:

### Step 1: Initialize Termux Environment
```bash
# Update local package index and upgrade packages
pkg update && pkg upgrade -y

# Install git, curl and proot-distro
pkg install git curl proot-distro -y
```

### Step 2: Set Up Ubuntu Distro
```bash
# Install Ubuntu Linux environment
proot-distro install ubuntu

# Login to Ubuntu container
proot-distro login ubuntu
```

### Step 3: Install Compiler Tools & Dependencies (Inside Ubuntu)
```bash
# Update Ubuntu package manager
apt update && apt upgrade -y

# Install python tools, compilation headers, and Rust compiler
apt install -y git python3 python3-pip python3-venv build-essential libssl-dev libffi-dev python3-dev rustc cargo curl
```

### Step 4: Clone the Project
```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus
```

### Step 5: Configure Virtual Environment & Package Tools
```bash
# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Upgrade installer tools
pip install --upgrade pip setuptools wheel
```

### Step 6: Install Python Requirements
```bash
pip install -r requirements.txt
```
> [!IMPORTANT]
> Compiling C/C++ and Rust extensions (such as `cryptography`, `greenlet`, or `pydantic-core`) inside an emulated PRoot environment on a phone can take **10 to 30 minutes**. Please do not close Termux.

### Step 7: Initialize Database & Seed Password
To pre-seed the admin password to `71807180`:
```bash
export ODYSSEUS_ADMIN_PASSWORD="71807180"
python3 setup.py
```
*(Alternatively, run `python3 setup.py` without the env variable to generate a random temporary password.)*

---

## 🔄 Running the Server

### ⚡ Using the Shortcut (Method 1)
If you used the automated installer, a startup script is placed in your Termux home directory:
```bash
chmod +x run.sh
./run.sh
```

### 💻 Using Raw Command (Method 2)
To start the server manually at any time:
```bash
proot-distro login ubuntu -- bash -c "cd odysseus && source venv/bin/activate && python3 -m uvicorn app:app --host 0.0.0.0 --port 7000"
```

Once running, navigate to `http://localhost:7000` (or `http://127.0.0.1:7000`) in your web browser.
