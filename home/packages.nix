{ config, pkgs, lib, isWSL ? false, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Packages that don't work in WSL2 (no Wayland, no X11 by default)
  wslExcludePackages = [
    "wl-clipboard"  # Wayland clipboard - not available in WSL2
  ];

  # Common packages for all platforms
  commonPackages = with pkgs; [
    # Search & Navigation
    ripgrep-all  # includes ripgrep functionality
    fd
    broot
    ghq

    # File viewers & converters
    bat
    hexyl
    viu

    # File management
    eza  # includes tree functionality (eza --tree)
    dust
    choose

    # Git tools
    gh
    lazygit  # primary Git TUI
    git-interactive-rebase-tool
    onefetch
    lefthook
    pre-commit

    # System monitoring
    bottom  # includes process viewer
    bandwhich
    gping

    # Terminal & Shell
    zellij

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

    # Network tools
    dog
    nmap
    mtr
    httpstat

    # Database tools
    usql  # universal SQL client (supports PostgreSQL, MySQL, SQLite, etc.)

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

    # AI Coding Agents
    claude-code    # Claude Code CLI (from claude-code-overlay)
    codex          # OpenAI Codex CLI (from llm-agents)
    opencode       # OpenCode CLI (from llm-agents)
    amp            # Amp CLI (from llm-agents)
    gemini-cli     # Google Gemini CLI (from llm-agents)
    copilot-cli    # GitHub Copilot CLI (from llm-agents)
    coderabbit-cli # CodeRabbit CLI (from llm-agents)

    # Build & Development
    act # GitHub Actions locally
    devenv # Modern development environment tool

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

    # Languages (nodejs/python managed via pnpm/uv)
    rustup
    go

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

    # Utilities
    tldr
    neofetch
    shellharden
    pueue

    # Other
    ko
  ];

  # macOS-specific packages
  darwinPackages = with pkgs; [
    # Mobile development (iOS)
    cocoapods
  ];

  # Linux-specific packages
  linuxPackagesBase = with pkgs; [
    # Clipboard utilities (required for fzf, zellij)
    xclip

    # System utilities
    inotify-tools
    lsof
    strace
    ltrace

    # Hardware info
    pciutils
    usbutils
    dmidecode

    # Network
    iproute2
    iptables
    ethtool
    tcpdump

    # Desktop integration (for GUI environments)
    xdg-utils
    desktop-file-utils

    # Fonts utilities
    fontconfig

    # Process management
    htop
    iotop

    # Filesystem
    ncdu
    duf
  ];

  # Packages only for non-WSL Linux (require Wayland/X11)
  linuxDesktopPackages = with pkgs; [
    wl-clipboard  # Wayland clipboard
  ];

  # Combined Linux packages with WSL filtering
  linuxPackages = linuxPackagesBase
    ++ lib.optionals (!isWSL) linuxDesktopPackages;
in
{
  home.packages = commonPackages
    ++ lib.optionals isDarwin darwinPackages
    ++ lib.optionals isLinux linuxPackages;
}
