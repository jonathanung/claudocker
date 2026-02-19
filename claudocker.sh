#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Build the image
docker build -f "$SCRIPT_DIR/Dockerfile.claude" -t claude-workspace "$SCRIPT_DIR"

# Run — mounts project as /workspace and ~/.claude for auth persistence
docker run -it --rm \
  -v "$SCRIPT_DIR/project:/workspace" \
  -v ~/.claude:/home/claude/.claude \
  claude-workspace "$@"
