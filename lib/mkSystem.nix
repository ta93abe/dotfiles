{ darwin, home-manager, nixpkgs, nixpkgs-unstable, ... }:

{ system, hostname, username, modules ? [], overlays ? [] }:

# NOTE: This function is not currently used in flake.nix, but is prepared
# for future use when managing multiple machines with different configurations.
# To use this function, update flake.nix to call mkSystem instead of
# directly defining darwinSystem.

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
        # Merge personal.nix with hostname/username to create complete personal object
        personal = (import ../personal.nix) // {
          inherit hostname username;
        };
      };
    }
  ] ++ modules;
}
