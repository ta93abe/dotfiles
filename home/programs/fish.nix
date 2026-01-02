{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      # Modern replacements
      cat = "bat";
      mkdir = "mkdir -p";
      ls = "eza -la";

      # Git abbreviations
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
    };

    shellAliases = {
      # Python
      python = "python3";

      # Modern CLI replacements
      ll = "eza -l";
      la = "eza -la";
      vim = "hx";
      top = "btm";
      ps = "procs";
      du = "dust";
      find = "fd";
      grep = "rg";
    };

    functions = {
      # ghq + fzf repository selector
      ghq_fzf_repo = ''
        set selected_repository (ghq list -p | fzf --query "$argv")
        if test -n "$selected_repository"
          cd $selected_repository
          commandline -f repaint
        end
      '';

      # Fish key bindings
      fish_user_key_bindings = ''
        bind \cf ghq_fzf_repo
      '';
    };

    interactiveShellInit = ''
      # Disable greeting
      set fish_greeting
    '';
  };
}
