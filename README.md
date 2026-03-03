# Claude Code Docker Workspace

Run [Claude Code](https://github.com/anthropics/claude-code) in a sandboxed Docker container with `--dangerously-skip-permissions` enabled.

## Prerequisites

- Docker
- An Anthropic API key (set `ANTHROPIC_API_KEY` in your environment), **or** an existing `~/.claude` directory from a prior `claude` login

## Quick Start

```bash
# 1. Place your project in ./project/ (or change the mount in claudocker.sh)
mkdir project && cp -r /path/to/your/repo/* project/

# 2. Run
./claudocker.sh
```

Claude Code starts inside a **tmux session** in `/workspace` with full permissions — no approval prompts.

## Files

| File | Purpose |
|---|---|
| `Dockerfile.claude` | Builds an Ubuntu 24.04 image with Claude Code (native installer), Oh My Zsh, and tmux |
| `entrypoint.claude.sh` | Marks `/workspace` as git-safe, registers the `clod` alias, restores `.claude.json` from backup if missing, and launches a tmux session |
| `claudocker.sh` | Build + run helper — mounts your project and `~/.claude` auth into the container |
| `claudocker-join.sh` | Join a running container (provides the `clod-join` function with tmux/zsh options) |

## Usage

### Running Claude Code

Once inside the container, you can start Claude Code with:

```bash
claude --dangerously-skip-permissions
# or use the alias
clod
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

`--dangerously-skip-permissions` gives Claude Code unrestricted shell access inside the container. The Docker boundary provides isolation, but review the mounted volumes — anything mounted in is accessible. Do not mount sensitive directories you don't want Claude to read or modify.
