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
- Nerd Fonts (FiraCode, JetBrainsMono, Hack, etc.)
- System packages (databases, DevOps tools, etc.)
- **Homebrew integration** for GUI apps and specialized tools

### User Configuration (home.nix)

- **100+ CLI tools** including:
  - Modern Unix tools (bat, eza, ripgrep, fd, etc.)
  - Git tools (delta, gitui, gh, etc.)
  - Development tools (helix, neovim, tmux, etc.)
  - System monitoring (bottom, procs, bandwhich, etc.)
- Programming languages (Node.js, Python, Rust, Go, Zig, Julia, etc.)
- Git configuration with delta integration
- Zsh with:
  - Syntax highlighting
  - Auto-completion
  - Modern aliases
  - Zoxide integration
  - fzf keybindings
- Starship prompt
- Helix editor configuration

### Homebrew Management

nix-darwin manages Homebrew declaratively:

- **GUI applications** (casks): Browsers, IDEs, design tools, etc.
- **Specialized CLI tools**: Cloud CLIs, version managers, etc.
- Automatic cleanup of unlisted packages

## Managing packages

Add packages to either:
- `darwin-configuration.nix` for system-wide packages and Homebrew casks/brews
- `home.nix` for user-specific packages

Then run `darwin-rebuild switch --flake .` to apply changes.

### Migrating from Homebrew

If you're migrating from Homebrew:

1. **CLI tools**: Most are available in nixpkgs and have been added to `home.nix`
2. **GUI apps**: Managed via nix-darwin's Homebrew module in `darwin-configuration.nix`
3. **Old Homebrew installations**: After applying the nix-darwin configuration, you can safely uninstall packages managed by nix-darwin:

```bash
# The configuration will automatically manage Homebrew
# Packages not in the config will be removed with cleanup = "zap"
darwin-rebuild switch --flake .
```

### Finding packages

Search for Nix packages:

```bash
# Search nixpkgs
nix search nixpkgs <package-name>

# Example
nix search nixpkgs ripgrep
```

## Troubleshooting

If you encounter issues:

```bash
# Clean build cache
nix-collect-garbage -d

# Rebuild from scratch
darwin-rebuild switch --flake . --recreate-lock-file
```