#!/bin/bash
set -e

CONTAINER="${1:-claude-workspace}"

docker exec -it "$CONTAINER" tmux attach -t workspace
