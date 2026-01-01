# dotfiles

My personal dotfiles managed with **nix-darwin** and **home-manager**.

## Philosophy: Nix-First Approach

This configuration prioritizes Nix packages over Homebrew:

- ✅ **CLI tools**: 100% managed by Nix via `home.nix`
- ✅ **System packages**: Managed by Nix via `darwin-configuration.nix`
- ⚠️ **GUI applications**: Managed by Homebrew Cask (only when unavailable in nixpkgs)

**Why Nix?**
- Declarative and reproducible
- Atomic upgrades and rollbacks
- Isolated package environments
- No dependency conflicts

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

### System Configuration (darwin-configuration.nix) - Nix Managed

- macOS system defaults (Dock, Finder, keyboard settings)
- Touch ID for sudo
- Nerd Fonts (FiraCode, JetBrainsMono, Hack, etc.) via Nix
- System packages (databases, DevOps tools, etc.) via Nix
- Minimal Homebrew integration (GUI apps ONLY)

### User Configuration (home.nix) - 100% Nix

- **110+ CLI tools** - ALL managed by Nix:
  - Modern Unix tools (bat, eza, ripgrep, fd, etc.)
  - Git tools (delta, gitui, gh, etc.)
  - Development tools (helix, neovim, tmux, etc.)
  - System monitoring (bottom, procs, bandwhich, etc.)
  - **Cloud CLIs** (AWS, Azure, GCP, Firebase, Fly.io) via Nix
  - **DevOps tools** (CircleCI, etc.) via Nix
  - **Python tools** (poetry, pipx) via Nix
  - **Mobile dev** (CocoaPods) via Nix
- Programming languages (Node.js, Python, Rust, Go, Zig, Julia, etc.) via Nix
- Git configuration with delta integration
- Zsh with:
  - Syntax highlighting
  - Auto-completion
  - Modern aliases
  - Zoxide integration
  - fzf keybindings
- Starship prompt
- Helix editor configuration

### Homebrew (Minimal Usage)

**Only for GUI applications** that are not available in nixpkgs:

- Browsers, IDEs, design tools
- macOS-specific GUI applications
- **Zero CLI tools via Homebrew** - all CLI tools use Nix
- Automatic cleanup of unlisted packages

## Managing packages

### Nix-First Policy

**Always prefer Nix over Homebrew:**

1. **For CLI tools**: Add to `home.nix` packages list
2. **For system packages**: Add to `darwin-configuration.nix` environment.systemPackages
3. **For GUI apps**: Only use Homebrew casks in `darwin-configuration.nix` if unavailable in nixpkgs

Then run `darwin-rebuild switch --flake .` to apply changes.

### Adding a new package

**Step 1: Search for the package in nixpkgs**

```bash
# Search nixpkgs
nix search nixpkgs <package-name>

# Example
nix search nixpkgs ripgrep
```

**Step 2: Add to the appropriate config file**

For CLI tools (most common):
```nix
# home.nix
packages = with pkgs; [
  # ... existing packages
  your-new-package
];
```

For GUI apps (last resort):
```nix
# darwin-configuration.nix
homebrew.casks = [
  # ... existing casks
  "your-gui-app"
];
```

**Step 3: Apply changes**

```bash
darwin-rebuild switch --flake .
```

### Migrating from Homebrew

If you're migrating from Homebrew:

1. **CLI tools**: ✅ All migrated to Nix in `home.nix`
2. **GUI apps**: Managed via Homebrew casks in `darwin-configuration.nix`
3. **Cleanup**: Homebrew packages not in config are auto-removed with `cleanup = "zap"`

```bash
# Apply the configuration - this will manage both Nix and Homebrew
darwin-rebuild switch --flake .

# Optional: List what Homebrew still manages
brew list --cask
```

## Troubleshooting

If you encounter issues:

```bash
# Clean build cache
nix-collect-garbage -d

# Rebuild from scratch
darwin-rebuild switch --flake . --recreate-lock-file
```