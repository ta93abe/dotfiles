# Darwin (macOS) configuration entry point
# =============================================================================
# Nix-First Philosophy
# =============================================================================
# This configuration prioritizes Nix packages over Homebrew.
# - ALL CLI tools are managed via Nix (see home/packages.nix)
# - System packages are managed via Nix (see environment.systemPackages below)
# - Homebrew is ONLY used for GUI applications (see homebrew.nix)
# =============================================================================
{ config, pkgs, lib, ... }:

{
  imports = [
    # Common Nix settings
    ../common/nix.nix

    # macOS-specific modules
    ./system.nix
    ./homebrew.nix
  ];

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

  # Services
  services = {
    nix-daemon.enable = true;
  };
}
