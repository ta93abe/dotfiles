{
  description = "Darwin system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
    let
      # Import personal configuration
      # Copy personal.nix.example to personal.nix and fill in your values
      personal = import ./personal.nix;
    in
    {
      darwinConfigurations = {
        "${personal.hostname}" = darwin.lib.darwinSystem {
          system = "aarch64-darwin"; # Use "x86_64-darwin" for Intel Macs
          modules = [
            ./darwin-configuration.nix

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
