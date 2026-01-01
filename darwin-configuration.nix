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
    vim
    git
    curl
    wget
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
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # Programs
  programs = {
    zsh.enable = true;
  };

  # Services
  services = {
    nix-daemon.enable = true;
  };

  # Used for backwards compatibility
  system.stateVersion = 5;
}
