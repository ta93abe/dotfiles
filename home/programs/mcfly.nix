{ config, pkgs, ... }:

{
  programs.mcfly = {
    enable = true;
    enableFishIntegration = true;
  };
}
