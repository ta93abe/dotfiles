{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    # You should update this to your username
    username = "your-username";
    homeDirectory = "/Users/your-username";

    # This value determines the Home Manager release that your configuration is compatible with
    stateVersion = "24.05";

    # Packages to install for this user
    packages = with pkgs; [
      # Development tools
      helix
      ripgrep
      fd
      bat
      eza
      fzf
      jq
      tree

      # Languages
      nodejs
      python3
      rustup
      go

      # CLI utilities
      htop
      tmux
      neofetch
      gh

      # Other
      starship
    ];

    # Environment variables
    sessionVariables = {
      EDITOR = "hx";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza";
      cat = "bat";
      vim = "hx";
    };

    initExtra = ''
      # Starship prompt
      eval "$(starship init zsh)"
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Helix editor configuration
  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        cursorline = true;
        auto-save = true;
        indent-guides.render = true;
      };
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
