#!/bin/bash
set -e

# Mark mounted volume as safe for git
git config --global --add safe.directory /workspace

# Register clod alias for zsh
echo 'alias clod="claude --dangerously-skip-permissions"' >> /home/claude/.zshrc

# Restore .claude.json from backup if missing
if [ ! -f /home/claude/.claude.json ]; then
    BACKUP=$(ls -t /home/claude/.claude/backups/.claude.json.backup.* 2>/dev/null | head -1)
    if [ -n "$BACKUP" ]; then
        cp "$BACKUP" /home/claude/.claude.json
        echo "[entrypoint] Restored .claude.json from backup"
    fi
fi

exec tmux new-session -s workspace
