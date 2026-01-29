# Helper function to create Darwin (macOS) system configurations
{ darwin, home-manager, lib }:

{ system, personal, overlays ? [] }:

darwin.lib.darwinSystem {
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

    # Darwin configuration (modularized)
    ../modules/darwin

    # Home Manager integration
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${personal.username} = import ../home;
      home-manager.extraSpecialArgs = { inherit personal; };
    }
  ];
}
