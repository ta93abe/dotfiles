# Example Linux standalone (non-NixOS / WSL2) machine configuration
# =============================================================================
# This file is for machine-specific Home Manager settings on non-NixOS Linux.
# Copy this file and rename it to your hostname.nix (e.g., wsl-ubuntu.nix)
# Then add the machine to flake.nix under homeConfigurations
#
# Usage (after adding to flake.nix):
#   home-manager switch --flake .#username@hostname
# =============================================================================
{ config, pkgs, lib, personal, ... }:

{
  # Machine-specific Home Manager settings

  # Additional packages for this machine
  # home.packages = with pkgs; [
  #   # Add machine-specific packages here
  # ];

  # WSL2-specific settings (uncomment if using WSL2)
  # home.sessionVariables = {
  #   # Access Windows files
  #   WINDOWS_HOME = "/mnt/c/Users/${personal.username}";
  # };

  # This assertion ensures the module is valid while keeping it minimal
  assertions = [
    {
      assertion = true;
      message = "machines/linux/example.nix is a template file.";
    }
  ];
}
