{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
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
}
