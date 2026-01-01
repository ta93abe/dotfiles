{ config, pkgs, ... }:

{
  # Nix configuration
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      # Optimize storage
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    git
    curl
    wget
    gnupg
    openssl

    # Build tools
    cmake
    protobuf

    # Databases & Services
    postgresql_14
    mariadb
    redis
    mongodb-community
    nginx

    # Cloud & DevOps
    docker
    docker-compose
    kubernetes
    terraform
    vault
    consul
    nomad
    packer

    # Container & VM tools
    colima
  ];

  # System configuration
  system = {
    # Set Git commit hash for darwin-rebuild
    configurationRevision = null;

    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        orientation = "bottom";
        show-recents = false;
        tilesize = 48;
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv"; # List view
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      # NSGlobalDomain settings
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
    };

    # Auto-upgrade
    stateVersion = 5;
  };

  # Enable Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "Hack"
        "Meslo"
        "RobotoMono"
      ];
    })
  ];

  # Programs
  programs = {
    zsh.enable = true;
  };

  # Services
  services = {
    nix-daemon.enable = true;
  };

  # Homebrew configuration
  # This allows nix-darwin to manage Homebrew declaratively
  homebrew = {
    enable = true;

    # Automatically update Homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap"; # Uninstall packages not listed in configuration
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
      "docker"
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
      "google-cloud-sdk"
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
    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
    ];

    # CLI tools that are better managed via Homebrew
    # (e.g., tools not in nixpkgs or with better Homebrew integration)
    brews = [
      # Cloud CLI tools
      "awscli"
      "azure-cli"
      "firebase-cli"
      "flyctl"

      # Specialized tools
      "chezmoi"
      "circleci"
      "cocoapods"

      # Language-specific version managers
      "anyenv"
      "pyenv"
      "poetry"
      "pipx"

      # Databases
      "neo4j"
      "meilisearch"
    ];
  };

  # Used for backwards compatibility
  system.stateVersion = 5;
}
