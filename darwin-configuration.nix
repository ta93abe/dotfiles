{ config, pkgs, ... }:

{
  # =============================================================================
  # Nix-First Philosophy
  # =============================================================================
  # This configuration prioritizes Nix packages over Homebrew.
  # - ALL CLI tools are managed via Nix (see home.nix)
  # - System packages are managed via Nix (see environment.systemPackages below)
  # - Homebrew is ONLY used for GUI applications (see homebrew.casks below)
  # =============================================================================

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

        # Custom keyboard shortcuts
        # Format: "Menu Item" = "Shortcut"
        # Shortcuts use: @ = Command, ^ = Control, ~ = Option, $ = Shift
        NSUserKeyEquivalents = {
          # Global shortcuts
          "Show Help menu" = "^~@/";
        };
      };

      # Screenshot settings
      screencapture = {
        location = "~/Documents";
        type = "png";
        disable-shadow = false;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true; # Enable tap to click
        TrackpadThreeFingerDrag = true; # Three finger drag
      };

      # Mouse settings
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 1.5;
      };

      # Menu bar settings
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1; # Always show date
        ShowDayOfWeek = true;
      };

      # Login window settings
      loginwindow = {
        GuestEnabled = false; # Disable guest user
        DisableConsoleAccess = true;
      };

      # Screen saver settings
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 5; # seconds
      };

      # Spaces settings
      spaces = {
        spans-displays = false; # Separate spaces per display
      };

      # Custom macOS preferences
      CustomUserPreferences = {
        # Modifier keys remapping: Caps Lock → Command
        "com.apple.keyboard.modifiermapping.1452-591-0" = [
          {
            HIDKeyboardModifierMappingDst = 30064771299;  # Command
            HIDKeyboardModifierMappingSrc = 30064771129;  # Caps Lock
          }
        ];

        # Input source switching: Option + Esc
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Select next source in Input menu
            "61" = {
              enabled = true;
              value = {
                parameters = [ 53 53 524288 ];  # Esc key (53) + Option (524288)
                type = "standard";
              };
            };
          };
        };
      };
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
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
    # Fish is configured in home-manager (home.nix)
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
