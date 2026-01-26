# Helper function to create NixOS system configurations
{ nixpkgs, home-manager, lib }:

{ system, personal, overlays ? [] }:

nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit personal;
  };

  modules = [
    # Apply overlays and allow unfree packages
    {
      nixpkgs.overlays = overlays;
      nixpkgs.config.allowUnfree = true;
    }

    # Machine-specific configuration (hardware, etc.)
    (../machines/nixos + "/${personal.hostname}.nix")

    # NixOS configuration (modularized)
    ../modules/nixos

    # Home Manager integration
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${personal.username} = import ../home;
      home-manager.extraSpecialArgs = { inherit personal; };
    }
  ];
}
