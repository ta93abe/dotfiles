{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Common packages for all platforms
  commonPackages = with pkgs; [
    # Search & Navigation
    ripgrep
    ripgrep-all
    fd
    broot
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
  linuxPackages = with pkgs; [
    # Clipboard utilities (required for fzf, zellij)
    xclip
    wl-clipboard

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
in
{
  home.packages = commonPackages
    ++ lib.optionals isDarwin darwinPackages
    ++ lib.optionals isLinux linuxPackages;
}
