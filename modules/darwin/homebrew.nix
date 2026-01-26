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

    # Install GUI applications via Homebrew Cask
    casks = [
      # Browsers
      "google-chrome"
      "firefox"
      "vivaldi"
      "opera-gx"
      "min"

      # Development tools
      "iterm2"
      "warp"
      "wezterm"
      "github"
      "gitkraken"
      "tower"
      "postman"
      "paw"
      "popsql"
      "azure-data-studio"
      "wireshark"

      # Design & Creative
      "figma"
      "abstract"
      "canva"
      "miro"
      "origami-studio"
      "protopie"
      "blender"
      "unity-hub"

      # Communication
      "zoom"
      "microsoft-teams"
      "asana"
      "linear-linear"

      # Productivity
      "raycast"
      "obsidian"
      "typora"
      "dynalist"
      "numi"
      "alt-tab"
      "karabiner-elements"
      "centered"
      "forecast"

      # Media & Entertainment
      "spotify"
      "kap"
      "descript"
      "steam"
      "epic-games"
      "gog-galaxy"
      "twitch"

      # Cloud & Database tools
      "confluent-cli"
      "redis-stack"
      "redis-stack-server"
      "redis-stack-redisinsight"

      # Programming environments
      "flutter"
      "anaconda"
      "rstudio"
      "qt-creator"
      "qt3dstudio"
      "neovide"
      "nteract"

      # Music & Audio
      "sonic-pi"
      "supercollider"
      "cycling74-max"
      "splice"
      "spark-ar-studio"

      # Other utilities
      "adobe-acrobat-reader"
      "google-japanese-ime"
      "mactex"
      "vagrant"
      "powershell"
      "owasp-zap"
      "authy"
      "session"
      "brewlet"
      "around"
      "tableau"
      "tableau-prep"
      "storyboarder"
      "openframeworks"
      "git-credential-manager-core"
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
