# dotfiles

My personal dotfiles managed with nix-darwin and home-manager.

## Prerequisites

- macOS
- [Nix package manager](https://nixos.org/download.html) installed with flake support

### Installing Nix

```bash
sh <(curl -L https://nixos.org/nix/install)
```

## Setup

### 1. Update configuration

Before applying the configuration, update the following files with your personal information:

**flake.nix:**
- Replace `your-hostname` with your Mac's hostname (find it with `scutil --get ComputerName`)
- Change `aarch64-darwin` to `x86_64-darwin` if you have an Intel Mac
- Replace `your-username` with your macOS username

**home.nix:**
- Replace `your-username` with your macOS username
- Update Git configuration (name and email)
- Customize packages and settings as needed

### 2. Build and apply configuration

First time setup:

```bash
# Build the configuration
nix build .#darwinConfigurations.your-hostname.system

# Apply the configuration
./result/sw/bin/darwin-rebuild switch --flake .
```

### 3. Update configuration

After making changes to the configuration files:

```bash
darwin-rebuild switch --flake .
```

## What's included

### System Configuration (darwin-configuration.nix)

- macOS system defaults (Dock, Finder, keyboard settings)
- Touch ID for sudo
- Nerd Fonts (FiraCode, JetBrainsMono)
- System packages

### User Configuration (home.nix)

- Development tools (helix, ripgrep, fd, bat, etc.)
- Programming languages (Node.js, Python, Rust, Go)
- Git configuration
- Zsh with syntax highlighting and custom aliases
- Starship prompt
- Helix editor configuration

## Managing packages

Add packages to either:
- `darwin-configuration.nix` for system-wide packages
- `home.nix` for user-specific packages

Then run `darwin-rebuild switch --flake .` to apply changes.

## Troubleshooting

If you encounter issues:

```bash
# Clean build cache
nix-collect-garbage -d

# Rebuild from scratch
darwin-rebuild switch --flake . --recreate-lock-file
```