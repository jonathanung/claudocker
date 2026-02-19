#!/bin/bash
set -e

# Mark mounted volume as safe for git
git config --global --add safe.directory /workspace

exec claude --dangerously-skip-permissions "$@"
