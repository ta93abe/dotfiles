{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Platform-specific clipboard command
  copyCommand = if isDarwin then "pbcopy"
    else if builtins.getEnv "WAYLAND_DISPLAY" != "" then "wl-copy"
    else "xclip -selection clipboard";
in
{
  # Ghostty terminal configuration
  xdg.configFile."ghostty/config".text = ''
    # Font configuration
    font-family = JetBrainsMono Nerd Font
    font-size = 14
    font-thicken = true

    # Theme: Tokyo Night
    background = 1a1b26
    foreground = c0caf5
    cursor-color = c0caf5
    selection-background = 33467c
    selection-foreground = c0caf5

    # Colors
    palette = 0=#15161e
    palette = 1=#f7768e
    palette = 2=#9ece6a
    palette = 3=#e0af68
    palette = 4=#7aa2f7
    palette = 5=#bb9af7
    palette = 6=#7dcfff
    palette = 7=#a9b1d6
    palette = 8=#414868
    palette = 9=#f7768e
    palette = 10=#9ece6a
    palette = 11=#e0af68
    palette = 12=#7aa2f7
    palette = 13=#bb9af7
    palette = 14=#7dcfff
    palette = 15=#c0caf5

    # Window
    window-padding-x = 10
    window-padding-y = 10
    window-decoration = true
    window-theme = dark

    # Tab bar
    tab-bar-position = top

    # Shell
    shell-integration = fish

    # Cursor
    cursor-style = block
    cursor-style-blink = true

    # Mouse
    mouse-hide-while-typing = true

    # Clipboard
    clipboard-read = allow
    clipboard-write = allow

    # Performance
    unfocused-split-opacity = 0.9
  '';

  # Zellij terminal multiplexer configuration
  xdg.configFile."zellij/config.kdl".text = ''
    // Theme: Tokyo Night
    theme "tokyo-night"

    themes {
      tokyo-night {
        fg "#c0caf5"
        bg "#1a1b26"
        black "#15161e"
        red "#f7768e"
        green "#9ece6a"
        yellow "#e0af68"
        blue "#7aa2f7"
        magenta "#bb9af7"
        cyan "#7dcfff"
        white "#a9b1d6"
        orange "#ff9e64"
      }
    }

    // UI Configuration
    simplified_ui true
    pane_frames false
    default_shell "fish"

    // Mouse support
    mouse_mode true
    scroll_buffer_size 10000

    // Copy mode
    copy_on_select true
    copy_command "${copyCommand}"

    // Session configuration
    default_layout "compact"

    // Keybindings
    keybinds {
      normal {
        // Pane management
        bind "Ctrl p" { SwitchToMode "Pane"; }

        // Tab management
        bind "Ctrl t" { SwitchToMode "Tab"; }

        // Resize mode
        bind "Ctrl r" { SwitchToMode "Resize"; }

        // Scroll mode
        bind "Ctrl s" { SwitchToMode "Scroll"; }

        // Session mode
        bind "Ctrl o" { SwitchToMode "Session"; }

        // Move mode
        bind "Ctrl h" { SwitchToMode "Move"; }

        // Quit
        bind "Ctrl q" { Quit; }
      }

      pane {
        // Split panes
        bind "v" { NewPane "Right"; SwitchToMode "Normal"; }
        bind "s" { NewPane "Down"; SwitchToMode "Normal"; }

        // Navigate panes
        bind "h" "Left" { MoveFocus "Left"; }
        bind "l" "Right" { MoveFocus "Right"; }
        bind "j" "Down" { MoveFocus "Down"; }
        bind "k" "Up" { MoveFocus "Up"; }

        // Close pane
        bind "x" { CloseFocus; SwitchToMode "Normal"; }

        // Fullscreen
        bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
      }

      tab {
        // New tab
        bind "n" { NewTab; SwitchToMode "Normal"; }

        // Navigate tabs
        bind "h" "Left" { GoToPreviousTab; }
        bind "l" "Right" { GoToNextTab; }

        // Close tab
        bind "x" { CloseTab; SwitchToMode "Normal"; }

        // Rename tab
        bind "r" { SwitchToMode "RenameTab"; }
      }

      resize {
        bind "h" "Left" { Resize "Increase Left"; }
        bind "j" "Down" { Resize "Increase Down"; }
        bind "k" "Up" { Resize "Increase Up"; }
        bind "l" "Right" { Resize "Increase Right"; }
        bind "=" { Resize "Increase"; }
        bind "-" { Resize "Decrease"; }
      }

      scroll {
        bind "e" { EditScrollback; SwitchToMode "Normal"; }
        bind "/" { SwitchToMode "EnterSearch"; SearchInput 0; }
        bind "j" "Down" { ScrollDown; }
        bind "k" "Up" { ScrollUp; }
        bind "d" { HalfPageScrollDown; }
        bind "u" { HalfPageScrollUp; }
      }
    }
  '';
}
