# WSL2 (Windows Subsystem for Linux 2) Home Manager configuration
# =============================================================================
# This file is for WSL2-specific Home Manager settings.
# Used with homeConfigurations in flake.nix for standalone Home Manager on WSL2.
#
# Usage:
#   nix run .#switch-home  (from WSL2)
# =============================================================================
{ config, pkgs, lib, personal, ... }:

let
  # Windows username (may differ from WSL username)
  windowsUsername = personal.windowsUsername or personal.username;
in
{
  # WSL2-specific packages
  home.packages = with pkgs; [
    wslu  # WSL utilities (wslview, etc.)
  ];

  # WSL2-specific environment variables
  home.sessionVariables = {
    # Path to Windows home directory
    WINDOWS_HOME = "/mnt/c/Users/${windowsUsername}";

    # Use Windows browser for opening URLs (via wslview)
    BROWSER = "wslview";
  };

  # Git configuration for WSL2
  programs.git.extraConfig = {
    # Prevent CRLF issues when working with Windows files
    core.autocrlf = "input";

    # Use Windows credential manager for Git credentials
    credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
  };

  # Fish shell WSL2-specific configuration
  programs.fish.interactiveShellInit = lib.mkAfter ''
    # WSL2-specific aliases
    alias open='wslview'
    alias explorer='explorer.exe'

    # Quick access to Windows home
    alias winhome='cd $WINDOWS_HOME'
  '';
}
