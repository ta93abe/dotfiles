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

      # System architecture
      system = "aarch64-darwin"; # Use "x86_64-darwin" for Intel Macs

      # Packages for scripts
      pkgs = import nixpkgs { inherit system; };

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
      # ==========================================================================
      # Darwin Configurations
      # ==========================================================================
      darwinConfigurations = {
        "${personal.hostname}" = darwin.lib.darwinSystem {
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

      # ==========================================================================
      # Apps - Simplified commands
      # ==========================================================================
      # Usage:
      #   nix run .#switch  - Build and apply configuration
      #   nix run .#build   - Build only (test)
      #   nix run .#update  - Update flake inputs
      # ==========================================================================
      apps.${system} = {
        # Build and switch to new configuration
        switch = {
          type = "app";
          program = toString (pkgs.writeShellScript "darwin-switch" ''
            set -e
            echo "🔄 Building and switching to new configuration..."
            sudo ${darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild switch --flake .#${personal.hostname}
            echo "✅ Done!"
          '');
        };

        # Build only (for testing)
        build = {
          type = "app";
          program = toString (pkgs.writeShellScript "darwin-build" ''
            set -e
            echo "🔨 Building configuration..."
            nix build .#darwinConfigurations.${personal.hostname}.system
            echo "✅ Build successful! Run 'nix run .#switch' to apply."
          '');
        };

        # Update flake inputs
        update = {
          type = "app";
          program = toString (pkgs.writeShellScript "flake-update" ''
            set -e
            echo "📦 Updating flake inputs..."
            nix flake update
            echo "✅ Done! Run 'nix run .#switch' to apply changes."
          '');
        };

        # Default app is switch
        default = self.apps.${system}.switch;
      };
    };
}
