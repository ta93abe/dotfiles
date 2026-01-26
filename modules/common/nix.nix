# Common Nix settings shared across all platforms
{ config, pkgs, lib, ... }:

{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      # Optimize storage
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
