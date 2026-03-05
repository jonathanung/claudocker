# AI Coding Agent Docker Workspace

Run AI coding agents in a sandboxed Docker container with permissions bypassed for autonomous operation.

## Included Tools

| Tool | Skip-permissions alias | Underlying command |
|---|---|---|
| [Claude Code](https://github.com/anthropics/claude-code) | `clod` | `claude --dangerously-skip-permissions` |
| [Cursor CLI](https://cursor.com/blog/cli) | `yolo-cursor` | `agent --force` |
| [OpenCode](https://opencode.ai) | `yolo-oc` | `opencode --dangerously-skip-permissions` |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `yolo-gem` | `gemini --yolo` |
| [Codex CLI](https://github.com/openai/codex) | `yolo-codex` | `codex --yolo` |

## Prerequisites

- Docker
- API keys for the tools you want to use (e.g. `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `GEMINI_API_KEY`, `CURSOR_API_KEY`)
- **Or** an existing `~/.claude` directory from a prior `claude` login (for Claude Code)

## Quick Start

```bash
# 1. Place your project in ./project/ (or change the mount in claudocker.sh)
mkdir project && cp -r /path/to/your/repo/* project/

# 2. Run
./claudocker.sh
```

The container launches a **tmux session** in `/workspace`. Use any of the aliases above to start an agent.

## Files

| File | Purpose |
|---|---|
| `Dockerfile.claude` | Ubuntu 24.04 image with all five AI coding tools, Node.js 20, TypeScript, Oh My Zsh, and tmux |
| `entrypoint.claude.sh` | Marks `/workspace` as git-safe, registers all aliases, restores `.claude.json` from backup if missing, and launches a tmux session |
| `claudocker.sh` | Build + run helper — mounts your project and `~/.claude` auth into the container |
| `claudocker-join.sh` | Join a running container (provides the `clod-join` function with tmux/zsh options) |

## Usage

### Running an Agent

Once inside the container:

```bash
# Claude Code
clod

# Cursor
yolo-cursor

# OpenCode
yolo-oc

# Gemini CLI
yolo-gem

# Codex CLI
yolo-codex
```

### Joining a Running Container

Source or run `claudocker-join.sh` to attach to an existing container:

```bash
# Default (bash shell, container name "claude-workspace")
./claudocker-join.sh

# Join with zsh
./claudocker-join.sh --zsh

# Join with a new tmux session
./claudocker-join.sh --tmux

# Join a specific container
./claudocker-join.sh my-container-name
```

### Passing Extra Args

Any arguments to `claudocker.sh` are forwarded to the entrypoint:

```bash
./claudocker.sh -p "fix the tests"
```

## Configuration

### Host UID (Linux users)

The default UID is `501` (macOS default). `claudocker.sh` automatically passes your host UID via `--build-arg HOST_UID=$(id -u)`.

To build manually:

```bash
docker build --build-arg HOST_UID=$(id -u) -f Dockerfile.claude -t claude-workspace .
```

### macOS Plugin Symlink

If you use Claude Code plugins installed on macOS, the container needs a symlink so the host paths resolve. `claudocker.sh` handles this automatically. To build manually:

```bash
docker build --build-arg HOST_USERNAME=$(whoami) -f Dockerfile.claude -t claude-workspace .
```

## Security Warning

The skip-permissions aliases give each tool unrestricted shell access inside the container. The Docker boundary provides isolation, but review the mounted volumes — anything mounted in is accessible. Do not mount sensitive directories you don't want the agents to read or modify.
