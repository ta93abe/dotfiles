{
  description = "Darwin system configuration";

  inputs = {
    # Stable nixpkgs (darwin-specific channel)
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

    # Unstable nixpkgs for latest packages
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, darwin, home-manager, ... }:
    let
      # Import personal configuration
      # Copy personal.nix.example to personal.nix and fill in your values
      personal = import ./personal.nix;

      # Overlays to access unstable packages
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            system = final.system;
            config.allowUnfree = true;
          };
        })
      ];
    in
    {
      darwinConfigurations = {
        "${personal.hostname}" = darwin.lib.darwinSystem {
          system = "aarch64-darwin"; # Use "x86_64-darwin" for Intel Macs

          specialArgs = {
            inherit personal;
          };

          modules = [
            # Apply overlays and allow unfree packages
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
            }

            # Machine-specific configuration
            (./machines + "/${personal.hostname}.nix")

            # Darwin configuration
            ./darwin-configuration.nix

            # Home Manager integration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${personal.username} = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit personal; };
            }
          ];
        };
      };
    };
}
