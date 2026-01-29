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

    # LLM Agents (Codex, OpenCode, Amp, etc.)
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };

    # Claude Code overlay (for latest Claude Code)
    claude-code-overlay = {
      url = "github:ryoppippi/claude-code-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, darwin, home-manager, llm-agents, claude-code-overlay, ... }:
    let
      # Import personal configuration
      # Copy personal.nix.example to personal.nix and fill in your values
      personal = import ./personal.nix;

      # Import library functions
      lib = import ./lib {
        inherit nixpkgs nixpkgs-unstable darwin home-manager;
      };

      # Overlays for all systems
      mkOverlays = system: [
        (lib.mkUnstableOverlay system)
        # Make llm-agents and claude-code-overlay available as _llm-agents and _claude-code-overlay
        (_final: _prev: {
          _llm-agents = llm-agents;
          _claude-code-overlay = claude-code-overlay;
        })
        # Claude Code from ryoppippi's overlay
        (final: prev: claude-code-overlay.overlays.default final prev)
        # AI tools from llm-agents
        (final: prev: {
          inherit (prev._llm-agents.packages.${system})
            codex
            opencode
            amp
            gemini-cli
            copilot-cli
            coderabbit-cli
            ;
        })
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
      homeConfigurations = {
        # Ubuntu configuration
        "${personal.username}@ubuntu" = lib.mkHomeConfig {
          system = "x86_64-linux";
          inherit personal;
          overlays = mkOverlays "x86_64-linux";
          extraModules = [ ./machines/linux/ubuntu.nix ];
        };

        # WSL2 configuration
        "${personal.username}@wsl2" = lib.mkHomeConfig {
          system = "x86_64-linux";
          personal = personal // { isWSL = true; };
          overlays = mkOverlays "x86_64-linux";
          extraModules = [ ./machines/linux/wsl2.nix ];
        };
      };

      # ========================================================================
      # Apps - Simplified commands for all platforms
      # ========================================================================
      # Usage:
      #   nix run .#switch       - Build and apply Darwin configuration (macOS)
      #   nix run .#build        - Build only Darwin (test)
      #   nix run .#switch-home  - Build and apply Home Manager configuration (Linux/WSL2)
      #   nix run .#build-home   - Build only Home Manager (test)
      #   nix run .#switch-nixos - Build and apply NixOS configuration
      #   nix run .#build-nixos  - Build only NixOS (test)
      #   nix run .#update       - Update flake inputs
      #   nix run .#list         - List all available configurations
      # ========================================================================
      apps = lib.forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          isDarwin = pkgs.stdenv.isDarwin;
          isLinux = pkgs.stdenv.isLinux;

          # Detect WSL2 environment
          isWSL = builtins.pathExists /proc/sys/fs/binfmt_misc/WSLInterop;

          # Determine Home Manager configuration name based on environment
          homeConfigName = if isWSL
            then "${personal.username}@wsl2"
            else "${personal.username}@ubuntu";
        in
        {
          # Build and switch to new Darwin configuration (macOS only)
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
                echo "Error: 'switch' is for macOS (Darwin) only."
                echo ""
                echo "For Linux/WSL2, use: nix run .#switch-home"
                echo "For NixOS, use: nix run .#switch-nixos"
                exit 1
              ''
            ));
          };

          # Build only Darwin (for testing)
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
                echo "Error: 'build' is for macOS (Darwin) only."
                echo ""
                echo "For Linux/WSL2, use: nix run .#build-home"
                echo "For NixOS, use: nix run .#build-nixos"
                exit 1
              ''
            ));
          };

          # Build and switch to Home Manager configuration (Linux/WSL2)
          switch-home = {
            type = "app";
            program = toString (pkgs.writeShellScript "switch-home" (
              if isLinux then ''
                set -e
                CONFIG_NAME="${homeConfigName}"
                echo "Building and switching to Home Manager configuration: $CONFIG_NAME"
                ${home-manager.packages.${system}.home-manager}/bin/home-manager switch --flake .#$CONFIG_NAME
                echo "Done!"
              '' else ''
                set -e
                echo "Error: 'switch-home' is for Linux/WSL2 only."
                echo "For macOS, use: nix run .#switch"
                exit 1
              ''
            ));
          };

          # Build only Home Manager (for testing)
          build-home = {
            type = "app";
            program = toString (pkgs.writeShellScript "build-home" (
              if isLinux then ''
                set -e
                CONFIG_NAME="${homeConfigName}"
                echo "Building Home Manager configuration: $CONFIG_NAME"
                nix build .#homeConfigurations.$CONFIG_NAME.activationPackage
                echo "Build successful! Run 'nix run .#switch-home' to apply."
              '' else ''
                set -e
                echo "Error: 'build-home' is for Linux/WSL2 only."
                echo "For macOS, use: nix run .#build"
                exit 1
              ''
            ));
          };

          # Build and switch to NixOS configuration
          switch-nixos = {
            type = "app";
            program = toString (pkgs.writeShellScript "switch-nixos" ''
              set -e
              echo "Error: NixOS configurations are not yet defined."
              echo "Add your NixOS machine to nixosConfigurations in flake.nix first."
              echo ""
              echo "Once configured, run:"
              echo "  sudo nixos-rebuild switch --flake .#<hostname>"
              exit 1
            '');
          };

          # Build only NixOS (for testing)
          build-nixos = {
            type = "app";
            program = toString (pkgs.writeShellScript "build-nixos" ''
              set -e
              echo "Error: NixOS configurations are not yet defined."
              echo "Add your NixOS machine to nixosConfigurations in flake.nix first."
              echo ""
              echo "Once configured, run:"
              echo "  nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel"
              exit 1
            '');
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

          # List all available configurations
          list = {
            type = "app";
            program = toString (pkgs.writeShellScript "list-configs" ''
              set -e
              echo "=== Available Configurations ==="
              echo ""
              echo "Darwin (macOS):"
              echo "  - ${personal.hostname}"
              echo "    Commands: nix run .#switch, nix run .#build"
              echo ""
              echo "Home Manager (Linux/WSL2):"
              echo "  - ${personal.username}@ubuntu"
              echo "  - ${personal.username}@wsl2"
              echo "    Commands: nix run .#switch-home, nix run .#build-home"
              echo ""
              echo "NixOS:"
              echo "  - (none configured)"
              echo "    Commands: nix run .#switch-nixos, nix run .#build-nixos"
              echo ""
              echo "Other commands:"
              echo "  - nix run .#update  - Update flake inputs"
              echo "  - nix run .#list    - Show this list"
            '');
          };

          # Default app is switch
          default = self.apps.${system}.switch;
        }
      );
    };
}
