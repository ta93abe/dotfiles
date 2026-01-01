{ config, pkgs, ... }:

{
  # =============================================================================
  # Home Manager Configuration - 100% Nix Managed
  # =============================================================================
  # ALL CLI tools, development tools, and programming languages are managed
  # via Nix packages below. No Homebrew CLI tools are used.
  # =============================================================================

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    # You should update this to your username
    username = "your-username";
    homeDirectory = "/Users/your-username";

    # This value determines the Home Manager release that your configuration is compatible with
    stateVersion = "24.05";

    # Packages to install for this user
    packages = with pkgs; [
      # Editors
      helix
      neovim
      emacs
      vim

      # Search & Navigation
      ripgrep
      ripgrep-all
      fd
      fzf
      peco
      sk # skim
      broot
      zoxide
      ghq

      # File viewers & converters
      bat
      hexyl
      viu

      # File management
      eza
      lsd
      tree
      dust
      choose

      # Git tools
      gh
      git-delta
      diff-so-fancy
      gitui
      tig
      git-interactive-rebase-tool
      onefetch
      lefthook
      pre-commit

      # System monitoring
      htop
      bottom
      procs
      bandwhich
      gping

      # Terminal & Shell
      tmux
      zellij
      nushell
      fish
      starship

      # Text processing
      jq
      jql
      fx
      jo
      sd
      grex
      xsv
      csview
      angle-grinder

      # HTTP clients
      httpie
      xh
      curl

      # Network tools
      dog

      # Build & Development
      act # GitHub Actions locally

      # Benchmarking
      hyperfine
      oha

      # Code analysis
      tokei
      fselect

      # Media
      ffmpeg
      gifski
      silicon

      # Data & Formats
      protobuf

      # Languages
      nodejs
      python310
      rustup
      go
      zig
      nim
      julia
      ocaml
      opam
      erlang
      elixir

      # Package managers & tools
      topgrade
      poetry
      pipx

      # Cloud & Infrastructure
      awscli2
      azure-cli
      google-cloud-sdk
      firebase-tools
      flyctl

      # DevOps & CI/CD
      circleci-cli

      # Mobile development
      cocoapods

      # Dotfiles management
      chezmoi

      # Utilities
      tldr
      neofetch
      shellharden
      pueue

      # Other
      ko
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
      # Modern replacements
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      cat = "bat";
      vim = "hx";
      top = "btm"; # bottom
      ps = "procs";
      du = "dust";
      find = "fd";
      grep = "rg";

      # Git aliases
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";

      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    initExtra = ''
      # Starship prompt
      eval "$(starship init zsh)"

      # Zoxide (better cd)
      eval "$(zoxide init zsh)"

      # fzf keybindings
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
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
