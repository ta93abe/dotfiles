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

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }: {
    darwinConfigurations = {
      # Replace "your-hostname" with your actual hostname
      # You can find it with: scutil --get ComputerName
      "your-hostname" = darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # Use "x86_64-darwin" for Intel Macs
        modules = [
          ./darwin-configuration.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.your-username = import ./home.nix;
          }
        ];
      };
    };
  };
}
