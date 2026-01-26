# Helper function to create standalone Home Manager configurations
# Used for non-NixOS Linux systems and WSL2
{ home-manager, nixpkgs, lib }:

{ system, personal, overlays ? [] }:

home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    inherit system;
    overlays = overlays;
    config.allowUnfree = true;
  };

  extraSpecialArgs = {
    inherit personal;
  };

  modules = [
    ../home

    # Machine-specific Home Manager configuration (optional)
    # Uncomment if you have machine-specific home configs
    # (../machines/linux + "/${personal.hostname}.nix")
  ];
}
