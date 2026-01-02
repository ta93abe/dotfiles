{ config, pkgs, personal, ... }:

{
  # =============================================================================
  # Home Manager Configuration - Modularized
  # =============================================================================
  # This is the main entry point for Home Manager configuration.
  # Individual program configurations are split into home/programs/ directory.
  # =============================================================================

  imports = [
    # Package list
    ./home/packages.nix

    # Program configurations
    ./home/programs/git.nix
    ./home/programs/fish.nix
    ./home/programs/starship.nix
    ./home/programs/helix.nix
    ./home/programs/fzf.nix
    ./home/programs/zoxide.nix
    ./home/programs/mcfly.nix

    # XDG configurations (Ghostty, Zellij)
    ./home/xdg.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = personal.username;
    homeDirectory = "/Users/${personal.username}";

    # This value determines the Home Manager release that your configuration is compatible with
    stateVersion = "24.05";

    # Environment variables
    sessionVariables = {
      EDITOR = "hx";
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
