{ darwin, home-manager, nixpkgs, nixpkgs-unstable, ... }:

{ system, hostname, username, modules ? [], overlays ? [] }:

darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit hostname username;
  };

  modules = [
    # Apply overlays
    { nixpkgs.overlays = overlays; }

    # Include machine-specific configuration if it exists
    (../machines + "/${hostname}.nix")

    # Include darwin configuration
    ../darwin-configuration.nix

    # Home Manager integration
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = import ../home.nix;
      home-manager.extraSpecialArgs = {
        personal = {
          inherit hostname username;
          git = import ../personal.nix;
        };
      };
    }
  ] ++ modules;
}
