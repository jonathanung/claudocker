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

Claude Code starts in `/workspace` with full permissions — no approval prompts.

## Files

| File | Purpose |
|---|---|
| `Dockerfile.claude` | Builds an Ubuntu 24.04 image with Node.js 20 and Claude Code |
| `entrypoint.claude.sh` | Marks `/workspace` as git-safe, then runs `claude --dangerously-skip-permissions` |
| `claudocker.sh` | Build + run helper — mounts your project and `~/.claude` auth into the container |

## Configuration

### Host UID (Linux users)

The default UID is `501` (macOS default). If your host UID differs, pass it at build time:

```bash
docker build --build-arg HOST_UID=$(id -u) -f Dockerfile.claude -t claude-workspace .
```

### macOS Plugin Symlink

If you use Claude Code plugins installed on macOS, the container needs a symlink so the host paths resolve. Pass your macOS username at build time:

```bash
docker build --build-arg HOST_USERNAME=$(whoami) -f Dockerfile.claude -t claude-workspace .
```

### Passing Extra Args

Any arguments to `claudocker.sh` are forwarded to `claude`:

```bash
./claudocker.sh -p "fix the tests"
```

## Security Warning

`--dangerously-skip-permissions` gives Claude Code unrestricted shell access inside the container. The Docker boundary provides isolation, but review the mounted volumes — anything mounted in is accessible. Do not mount sensitive directories you don't want Claude to read or modify.
