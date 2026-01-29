# Homebrew configuration for macOS
# This allows nix-darwin to manage Homebrew declaratively
{ config, pkgs, lib, ... }:

{
  homebrew = {
    enable = true;

    # Automatically update Homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall"; # Safely uninstall packages not listed in configuration
    };

    # CLI tools not available in nixpkgs
    brews = [
      "tenv"  # Terraform/OpenTofu version manager
    ];

    # Install GUI applications via Homebrew Cask
    casks = [
      # Browsers
      "google-chrome"
      "firefox"
      "brave-browser"
      "arc"
      "thebrowsercompany-dia"

      # Development tools
      "wireshark"

      # Design & Creative
      "figma"
      "blender"
      "unity-hub"

      # Communication
      "zoom"
      "linear-linear"

      # Productivity
      "raycast"
      "obsidian"
      "numi"
      "alt-tab"
      "karabiner-elements"
      "centered"
      "forecast"

      # Media & Entertainment
      "spotify"
      "kap"
      "steam"
      "epic-games"
      "gog-galaxy"
      "twitch"

      # Programming environments
      "flutter"

      # Music & Audio
      "sonic-pi"
      "supercollider"
      "cycling74-max"
      "splice"

      # Other utilities
      "adobe-acrobat-reader"
      "google-japanese-ime"
      "openframeworks"
    ];

    # Additional taps (repositories)
    # Only for GUI applications and tools not available in nixpkgs
    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
    ];

    # Note: CLI tools are managed via Nix packages in home.nix
    # Homebrew is used ONLY for GUI applications (casks) that are not available in nixpkgs
  };
}
