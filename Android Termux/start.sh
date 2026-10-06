#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# ppSR Scene & Map Teleporter - Termux / Android Launcher Script
# ==============================================================================

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verify Python 3 installation
if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
elif command -v python &>/dev/null; then
    PYTHON_CMD="python"
else
    echo -e "\033[91m[!] Python is not installed in Termux / Android environment!\033[0m"
    echo -e "Please install Python by executing:"
    echo -e "  \033[92mpkg update && pkg install python -y\033[0m\n"
    exit 1
fi

# Run teleporter script
exec "$PYTHON_CMD" "$SCRIPT_DIR/teleport.py" "$@"
