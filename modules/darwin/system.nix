# macOS system settings (Dock, Finder, Touch ID, keyboard, etc.)
{ config, pkgs, lib, ... }:

{
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
        # Modifier keys remapping: Caps Lock -> Command
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
}
