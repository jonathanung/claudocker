#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Build the image
docker build -f "$SCRIPT_DIR/Dockerfile.claude" -t claude-workspace "$SCRIPT_DIR" \
  --build-arg HOST_UID="$(id -u)" \
  --build-arg HOST_OS=$(uname -s) \
  --build-arg HOST_USERNAME=$(whoami)

# Run — mounts project as /workspace and ~/.claude for auth persistence
docker run -it --rm \
  -v "$SCRIPT_DIR/project:/workspace" \
  -v ~/.claude:/home/claude/.claude \
  -v ~/.claude.json:/home/claude/.claude.json \
  claude-workspace "$@"
