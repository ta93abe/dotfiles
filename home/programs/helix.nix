{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "monokai";
      editor = {
        line-number = "relative";
        cursorline = true;
        auto-save = true;
        indent-guides.render = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
