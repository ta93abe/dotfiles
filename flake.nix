{
  description = "Multi-platform Nix configuration (macOS, Linux, WSL2)";

  inputs = {
    # Stable nixpkgs (supports both Darwin and NixOS)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Unstable nixpkgs for latest packages
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin for macOS
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
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

      # Import library functions
      lib = import ./lib {
        inherit nixpkgs nixpkgs-unstable darwin home-manager;
      };

      # Unstable overlay for all systems
      mkOverlays = system: [
        (lib.mkUnstableOverlay system)
      ];
    in
    {
      # ========================================================================
      # Darwin Configurations (macOS)
      # ========================================================================
      darwinConfigurations = {
        "${personal.hostname}" = lib.mkDarwinSystem {
          system = "aarch64-darwin"; # Use "x86_64-darwin" for Intel Macs
          inherit personal;
          overlays = mkOverlays "aarch64-darwin";
        };
      };

      # ========================================================================
      # NixOS Configurations (Linux with NixOS)
      # ========================================================================
      # Uncomment and configure when adding NixOS machines
      # nixosConfigurations = {
      #   "nixos-hostname" = lib.mkNixosSystem {
      #     system = "x86_64-linux";
      #     personal = {
      #       hostname = "nixos-hostname";
      #       username = "your-username";
      #       email = "your@email.com";
      #       name = "Your Name";
      #     };
      #     overlays = mkOverlays "x86_64-linux";
      #   };
      # };

      # ========================================================================
      # Home Configurations (Standalone Home Manager for non-NixOS Linux / WSL2)
      # ========================================================================
      # Uncomment and configure when adding standalone Home Manager setups
      # homeConfigurations = {
      #   "username@hostname" = lib.mkHomeConfig {
      #     system = "x86_64-linux";
      #     personal = {
      #       hostname = "linux-hostname";
      #       username = "your-username";
      #       email = "your@email.com";
      #       name = "Your Name";
      #     };
      #     overlays = mkOverlays "x86_64-linux";
      #   };
      # };

      # ========================================================================
      # Apps - Simplified commands for all platforms
      # ========================================================================
      # Usage:
      #   nix run .#switch  - Build and apply configuration (Darwin)
      #   nix run .#build   - Build only (test)
      #   nix run .#update  - Update flake inputs
      # ========================================================================
      apps = lib.forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          isDarwin = pkgs.stdenv.isDarwin;
        in
        {
          # Build and switch to new configuration
          switch = {
            type = "app";
            program = toString (pkgs.writeShellScript "switch" (
              if isDarwin then ''
                set -e
                echo "Building and switching to new Darwin configuration..."
                sudo ${darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild switch --flake .#${personal.hostname}
                echo "Done!"
              '' else ''
                set -e
                echo "Error: Use 'sudo nixos-rebuild switch --flake .#hostname' for NixOS"
                echo "Or use 'home-manager switch --flake .#user@hostname' for standalone Home Manager"
                exit 1
              ''
            ));
          };

          # Build only (for testing)
          build = {
            type = "app";
            program = toString (pkgs.writeShellScript "build" (
              if isDarwin then ''
                set -e
                echo "Building Darwin configuration..."
                nix build .#darwinConfigurations.${personal.hostname}.system
                echo "Build successful! Run 'nix run .#switch' to apply."
              '' else ''
                set -e
                echo "Error: 'build' app is not supported for non-Darwin systems. Please build explicitly." >&2
                echo "  For NixOS: nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel" >&2
                echo "  For Home Manager: nix build .#homeConfigurations.<user@hostname>.activationPackage" >&2
                exit 1
              ''
            ));
          };

          # Update flake inputs
          update = {
            type = "app";
            program = toString (pkgs.writeShellScript "flake-update" ''
              set -e
              echo "Updating flake inputs..."
              nix flake update
              echo "Done! Run the appropriate switch command to apply changes."
            '');
          };

          # Default app is switch
          default = self.apps.${system}.switch;
        }
      );
    };
}
