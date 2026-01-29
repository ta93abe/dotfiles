# Ubuntu standalone Home Manager configuration
# =============================================================================
# This file is for Ubuntu-specific Home Manager settings.
# Used with homeConfigurations in flake.nix for standalone Home Manager on Ubuntu.
#
# Usage:
#   nix run .#switch-home  (from Ubuntu)
# =============================================================================
{ config, pkgs, lib, personal, ... }:

{
  # Ubuntu-specific packages
  home.packages = with pkgs; [
    # Add Ubuntu-specific packages here if needed
  ];

  # Ubuntu-specific environment variables
  home.sessionVariables = {
    # Add Ubuntu-specific environment variables here
  };
}
