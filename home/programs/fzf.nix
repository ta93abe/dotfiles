{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;

  # Platform-specific clipboard command
  copyCommand = if isDarwin then "pbcopy"
    else if builtins.getEnv "WAYLAND_DISPLAY" != "" then "wl-copy"
    else "xclip -selection clipboard";
in
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    # Default command using fd for better performance
    defaultCommand = "fd --type f --hidden --follow --exclude .git";

    # Command for Ctrl+T (file search)
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";

    # Command for Alt+C (directory search)
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";

    # Default options
    defaultOptions = [
      # Layout
      "--height 60%"
      "--reverse"
      "--border rounded"
      "--info inline"

      # Preview
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
      "--preview-window right:50%:wrap"

      # Colors (Tokyo Night theme)
      "--color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7"
      "--color=fg+:#c0caf5,bg+:#1a1b26,hl+:#7dcfff"
      "--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff"
      "--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"

      # Behavior
      "--multi"
      "--cycle"
      "--bind 'ctrl-/:toggle-preview'"
      "--bind 'ctrl-u:preview-half-page-up'"
      "--bind 'ctrl-d:preview-half-page-down'"
      "--bind 'ctrl-a:select-all'"
      "--bind 'ctrl-y:execute-silent(echo {+} | ${copyCommand})'"
    ];
  };
}
