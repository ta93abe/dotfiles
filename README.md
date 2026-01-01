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

## Complete Setup Guide

### Step 1: Install Nix Package Manager

Install Nix with flake support:

```bash
# Install Nix (official installer)
sh <(curl -L https://nixos.org/nix/install)

# Restart your shell
exec $SHELL

# Verify installation
nix --version
```

**Expected output**: `nix (Nix) 2.x.x`

### Step 2: Clone this Repository

```bash
# Clone to your desired location
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Step 3: Create Personal Configuration

**Create your personal configuration file:**

```bash
# Copy the template
cp personal.nix.example personal.nix
```

**Get your system information:**

```bash
# Get your hostname
scutil --get ComputerName
# Example output: "MacBook-Pro"

# Get your username
whoami
# Example output: "john"
```

**Edit `personal.nix` with your information:**

```nix
{
  # System configuration
  hostname = "MacBook-Pro";  # ← Your actual hostname
  username = "john";         # ← Your actual username

  # Git configuration
  git = {
    userName = "John Doe";              # ← Your name
    userEmail = "john@example.com";     # ← Your email
  };
}
```

**Important Notes:**
- `personal.nix` is gitignored and won't be committed
- Keep `personal.nix.example` as a template for other machines
- Update architecture in `flake.nix` line 27 if using Intel Mac (`x86_64-darwin`)

### Step 4: Initial Build & Apply

**First-time installation:**

```bash
# Build the configuration (this may take 10-30 minutes)
# The hostname is read from your personal.nix file
nix build .#darwinConfigurations.$(nix eval --raw .#darwinConfigurations --apply 'x: builtins.head (builtins.attrNames x)').system

# Or simply use your hostname directly (from personal.nix)
nix build .#darwinConfigurations.YOUR-HOSTNAME.system

# Apply the configuration
./result/sw/bin/darwin-rebuild switch --flake .

# Set fish as your default shell
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

**What happens during build:**
- Downloads 124+ CLI tools
- Downloads programming languages
- Configures system settings
- Sets up Homebrew for GUI apps
- Configures fish shell

### Step 5: Restart Terminal

```bash
# Restart your terminal or run
exec fish

# Verify installation
which helix   # Should show nix store path
which fzf     # Should show nix store path
starship --version  # Should work
```

### Step 6: Post-Installation

**Verify everything works:**

```bash
# Test modern CLI tools
eza -la       # Better ls
bat README.md # Better cat
rg "nix"      # Better grep

# Test shell integration
zoxide --version  # Smart cd
mcfly --version   # History search

# Test Kubernetes tools (if using)
k9s version
helm version

# Test database tools
usql --version
```

**Check Homebrew GUI apps:**

```bash
# List installed casks
brew list --cask

# Should show: chrome, firefox, docker, etc.
```

## Updating Your System

### Daily Usage

**Apply configuration changes:**

```bash
cd ~/.dotfiles

# After editing any .nix files
darwin-rebuild switch --flake .
```

**Update packages:**

```bash
# Update flake inputs
nix flake update

# Rebuild with updated packages
darwin-rebuild switch --flake .
```

### Adding New Packages

**1. Search for package:**

```bash
nix search nixpkgs ripgrep
```

**2. Add to `home.nix`:**

```nix
packages = with pkgs; [
  # ... existing packages
  your-new-package
];
```

**3. Apply:**

```bash
darwin-rebuild switch --flake .
```

### Removing Packages

**1. Remove from `home.nix`**

**2. Apply and clean up:**

```bash
darwin-rebuild switch --flake .
nix-collect-garbage -d
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
  - **Python tools** (uv - modern package manager) via Nix
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

### Common Issues

#### Issue 1: "experimental-features" error

**Error:**
```
error: experimental Nix feature 'nix-command' is disabled
```

**Solution:**
```bash
# Create/edit nix config
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

#### Issue 2: Build fails with "permission denied"

**Solution:**
```bash
# Ensure Nix is properly installed
sudo nix-daemon
# Or restart
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

#### Issue 3: Homebrew conflicts

**Error:**
```
Warning: formula/cask is already installed
```

**Solution:**
```bash
# Let nix-darwin manage it
darwin-rebuild switch --flake .

# If still conflicts, uninstall manually
brew uninstall --cask <app-name>
```

#### Issue 4: Fish shell not activating

**Solution:**
```bash
# Check if fish is in allowed shells
cat /etc/shells | grep fish

# If not, add it
echo $(which fish) | sudo tee -a /etc/shells

# Change shell
chsh -s $(which fish)

# Logout and login again
```

#### Issue 5: Slow rebuild

**Solution:**
```bash
# Use binary cache
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update

# Or rebuild with max-jobs
darwin-rebuild switch --flake . --max-jobs auto
```

### Maintenance Commands

**Clean up old generations:**

```bash
# List generations
nix-env --list-generations

# Delete old generations (keep last 5)
nix-env --delete-generations +5

# Collect garbage
nix-collect-garbage -d

# Optimize store
nix-store --optimise
```

**Reset to fresh state:**

```bash
# Remove all old generations
sudo nix-collect-garbage -d

# Rebuild from scratch
darwin-rebuild switch --flake . --recreate-lock-file
```

**Check what's using disk space:**

```bash
# Show store paths and sizes
nix path-info -rsSh /run/current-system | sort -k2 -h
```

### Getting Help

- **Nix Manual**: https://nixos.org/manual/nix/stable/
- **nix-darwin**: https://github.com/LnL7/nix-darwin
- **Home Manager**: https://nix-community.github.io/home-manager/
- **Search packages**: https://search.nixos.org/packages

### Useful Commands Reference

```bash
# Show current configuration
darwin-rebuild --show-trace switch --flake .

# Rollback to previous generation
darwin-rebuild rollback

# List installed packages
nix-env -q

# Check package details
nix-info

# Test configuration without applying
darwin-rebuild build --flake .
```