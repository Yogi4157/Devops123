#!/bin/bash
set -xeuo pipefail

# Ensure we are in the Jenkins workspace
cd "${WORKSPACE:-/home/jenkins/retro/workspace/dev-jen}" || { echo "Workspace not found"; exit 1; }

echo "=== PWD ==="
pwd

echo "=== Listing top-level files and dirs ==="
ls -la

# Try to find the script (limit depth so it's fast)
SCRIPT=$(find . -maxdepth 4 -type f -iname 'create_ec2_from_template.sh' -print -quit || true)

if [ -z "$SCRIPT" ]; then
  echo "ERROR: create_ec2_from_template.sh not found in workspace."
  echo "Files in workspace (depth 3):"
  find . -maxdepth 3 -type f -printf '%P\n' || true
  echo ""
  echo "If the script is in your repo, make sure it is committed & pushed to the branch Jenkins checks out."
  # Optional: fail with a clear exit code
  exit 2
fi

echo "Found script at: $SCRIPT"
echo "Permissions before fix:"
ls -l "$SCRIPT"

# Convert CRLF->LF if needed
if grep -q $'\r' "$SCRIPT" 2>/dev/null; then
  echo "Converting CRLF to LF"
  sed -i 's/\r$//' "$SCRIPT"
fi

# Ensure executable
chmod +x "$SCRIPT" || true
echo "Permissions after fix:"
ls -l "$SCRIPT"

# Run with bash so shebang issues won't block; -x for trace
bash -x "$SCRIPT"


