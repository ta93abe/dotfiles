{ config, pkgs, personal, ... }:

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
      # Editor
      helix

      # Search & Navigation
      ripgrep
      ripgrep-all
      fd
      fzf
      broot
      zoxide
      ghq

      # File viewers & converters
      bat
      hexyl
      viu

      # File management
      eza
      tree
      dust
      choose

      # Git tools
      gh
      git-delta
      gitui
      tig
      git-interactive-rebase-tool
      onefetch
      lefthook
      pre-commit

      # System monitoring
      bottom
      procs
      bandwhich
      gping

      # Terminal & Shell
      zellij
      fish
      starship
      mcfly
      direnv

      # Text processing
      jq
      fx
      jo
      sd
      grex
      xsv
      csview
      angle-grinder

      # HTTP clients
      xh
      curl

      # Network tools
      dog
      nmap
      mtr
      httpstat

      # Database tools
      usql
      pgcli
      mycli
      litecli

      # Shell tools
      shellcheck
      shfmt

      # Kubernetes tools
      k9s
      helm
      kubectx
      stern

      # YAML/TOML tools
      yq
      dasel

      # Documentation
      pandoc
      mdbook
      glow

      # Security & Secrets
      age
      sops

      # Compression
      p7zip
      zstd

      # File sync
      rsync
      rclone

      # Image processing
      imagemagick

      # API tools
      grpcurl

      # Performance
      samply

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
      uv # Modern Python package manager (replaces poetry/pipx)
      pnpm # Fast, disk space efficient Node.js package manager

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
    userName = personal.git.userName;
    userEmail = personal.git.userEmail;

    # Delta (シンタックスハイライト付きdiff)
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "OneHalfDark";
      };
    };

    extraConfig = {
      # 基本設定
      init.defaultBranch = "main";
      pull.rebase = false;

      # カラー設定
      color.ui = "auto";

      # エディタ設定
      core.editor = "hx";

      # プッシュ設定
      push = {
        default = "simple";
        autoSetupRemote = true;
      };

      # マージ設定
      merge.conflictstyle = "diff3";

      # Rebase設定
      rebase.autoStash = true;

      # Fetch設定
      fetch.prune = true;

      # Diff設定
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };
    };

    # Git aliases
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --graph --oneline --decorate --all";
      amend = "commit --amend --no-edit";
    };

    # グローバル ignore設定
    ignores = [
      ".DS_Store"
      "*.swp"
      "*.swo"
      "*~"
      ".vscode/"
      ".idea/"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
    ];
  };

  # Fish configuration
  programs.fish = {
    enable = true;

    shellAbbrs = {
      # Modern replacements
      cat = "bat";
      mkdir = "mkdir -p";
      ls = "eza -la";

      # Git abbreviations
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
    };

    shellAliases = {
      # Python
      python = "python3";

      # Modern CLI replacements
      ll = "eza -l";
      la = "eza -la";
      vim = "hx";
      top = "btm";
      ps = "procs";
      du = "dust";
      find = "fd";
      grep = "rg";
    };

    functions = {
      # ghq + fzf repository selector
      ghq_fzf_repo = ''
        set selected_repository (ghq list -p | fzf --query "$argv")
        if test -n "$selected_repository"
          cd $selected_repository
          commandline -f repaint
        end
      '';

      # Fish key bindings
      fish_user_key_bindings = ''
        bind \cf ghq_fzf_repo
      '';
    };

    interactiveShellInit = ''
      # Disable greeting
      set fish_greeting

      # Initialize tools
      zoxide init fish | source
      starship init fish | source
      mcfly init fish | source
      direnv hook fish | source

      # fzf key bindings
      set -gx FZF_DEFAULT_OPTS "--height 40% --reverse --border"
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[🎣](blue)";
        error_symbol = "[✖](bold red) ";
      };

      directory = {
        truncation_length = 7;
        truncation_symbol = ".../";
        format = "[$path]($style)[$lock_symbol]($lock_style) ";
      };

      battery = {
        full_symbol = "🔋";
        charging_symbol = "🔌";
        discharging_symbol = "⚡";
        display = [{
          threshold = 30;
          style = "bold red";
        }];
      };

      cmd_duration = {
        min_time = 10000;
        format = " took [$duration]($style)";
      };

      git_branch = {
        format = " [$symbol$branch]($style) ";
        symbol = "🍣 ";
        style = "bold yellow";
      };

      git_commit = {
        commit_hash_length = 8;
        style = "bold white";
      };

      git_state = {
        format = "[($state( $progress_current of $progress_total))]($style) ";
      };

      git_status = {
        conflicted = "⚔️ ";
        ahead = "🏎️ 💨 ×\${count}";
        behind = "🐢 ×\${count}";
        diverged = "🔱 🏎️ 💨 ×\${ahead_count} 🐢 ×\${behind_count}";
        untracked = "🛤️  ×\${count}";
        stashed = "📦 ";
        modified = "📝 ×\${count}";
        staged = "🗃️  ×\${count}";
        renamed = "📛 ×\${count}";
        deleted = "🗑️  ×\${count}";
        style = "bright-white";
        format = "$all_status$ahead_behind";
      };

      hostname = {
        ssh_only = false;
        format = "<[$hostname]($style)>";
        trim_at = "-";
        style = "bold dimmed white";
        disabled = true;
      };

      julia = {
        format = "[$symbol$version]($style) ";
        symbol = "ஃ ";
        style = "bold green";
      };

      memory_usage = {
        format = "$symbol[\${ram}( | \${swap})]($style) ";
        threshold = 70;
        style = "bold dimmed white";
        disabled = true;
      };

      package = {
        disabled = true;
      };

      python = {
        format = "[$symbol$version]($style) ";
        style = "bold green";
      };

      rust = {
        format = "[$symbol$version]($style) ";
        style = "bold green";
      };

      time = {
        time_format = "%T";
        format = "🕙 $time($style) ";
        style = "bright-white";
        disabled = true;
      };

      username = {
        style_user = "bold dimmed blue";
        show_always = false;
      };
    };
  };

  # Helix editor configuration
  programs.helix = {
    enable = true;
    settings = {
      theme = "monokai";
      editor = {
        line-number = "relative";
        cursorline = true;
        auto-save = true;
        indent-guides.render = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
