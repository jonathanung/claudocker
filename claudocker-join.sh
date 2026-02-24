#!/bin/bash
set -e

CONTAINER="${1:-claude-workspace}"

docker exec -it "$CONTAINER" tmux new-session
