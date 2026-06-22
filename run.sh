#!/data/data/com.termux/files/usr/bin/bash

# Start Odysseus server inside proot-distro Ubuntu
proot-distro login ubuntu -- bash -c "cd odysseus && source venv/bin/activate && python3 -m uvicorn app:app --host 0.0.0.0 --port 7000"
