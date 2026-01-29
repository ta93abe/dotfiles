# Home Manager Configuration - Modularized with Platform Support
# =============================================================================
# This is the main entry point for Home Manager configuration.
# Individual program configurations are split into home/programs/ directory.
# =============================================================================
{ config, pkgs, lib, personal, isWSL ? false, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Platform-specific home directory
  homeDirectory = if isDarwin
    then "/Users/${personal.username}"
    else "/home/${personal.username}";
in
{
  # Propagate isWSL to child modules
  _module.args.isWSL = isWSL;
  imports = [
    # Package list
    ./packages.nix

    # Program configurations
    ./programs/git.nix
    ./programs/fish.nix
    ./programs/starship.nix
    ./programs/helix.nix
    ./programs/fzf.nix
    ./programs/zoxide.nix
    ./programs/mcfly.nix
    ./programs/claude.nix

    # XDG configurations (Ghostty, Zellij)
    ./xdg.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = personal.username;
    inherit homeDirectory;

    # This value determines the Home Manager release that your configuration is compatible with
    stateVersion = "24.11";

    # Environment variables
    sessionVariables = {
      EDITOR = "hx";
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
