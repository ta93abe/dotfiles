# Helper function to create standalone Home Manager configurations
# Used for non-NixOS Linux systems and WSL2
{ home-manager, nixpkgs, lib }:

{ system, personal, overlays ? [], extraModules ? [] }:

let
  # Determine if this is a WSL2 environment
  isWSL = personal.isWSL or false;
in
home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    inherit system;
    overlays = overlays;
    config.allowUnfree = true;
  };

  extraSpecialArgs = {
    inherit personal isWSL;
  };

  modules = [
    ../home
  ] ++ extraModules;
}
