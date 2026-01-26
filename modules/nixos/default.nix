# NixOS configuration entry point
# =============================================================================
# This module contains common NixOS settings.
# Machine-specific hardware configuration should go in machines/nixos/*.nix
# =============================================================================
{ config, pkgs, lib, personal, ... }:

{
  imports = [
    # Common Nix settings
    ../common/nix.nix
  ];

  # Basic system configuration
  networking.hostName = personal.hostname;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # User configuration
  users.users.${personal.username} = {
    isNormalUser = true;
    description = personal.name;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    curl
    wget
    gnupg
    openssl

    # Build tools
    cmake
    gcc
    gnumake

    # Clipboard utilities for Linux
    xclip
    wl-clipboard
  ];

  # Enable Fish shell system-wide
  programs.fish.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "24.11";
}
