# Library of helper functions for building system configurations
{ nixpkgs, nixpkgs-unstable, darwin, home-manager, ... }:

let
  # Supported systems
  supportedSystems = [
    "aarch64-darwin"
    "x86_64-darwin"
    "x86_64-linux"
    "aarch64-linux"
  ];

  # Helper to generate attributes for all systems
  forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;

  # Create unstable overlay
  mkUnstableOverlay = system: (final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  });
in
{
  inherit supportedSystems forAllSystems mkUnstableOverlay;

  # Import individual builders
  mkDarwinSystem = import ./mkDarwinSystem.nix {
    inherit darwin home-manager;
    lib = nixpkgs.lib;
  };

  mkNixosSystem = import ./mkNixosSystem.nix {
    inherit nixpkgs home-manager;
    lib = nixpkgs.lib;
  };

  mkHomeConfig = import ./mkHomeConfig.nix {
    inherit home-manager nixpkgs;
    lib = nixpkgs.lib;
  };
}
