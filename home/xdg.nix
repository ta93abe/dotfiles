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

    # Theme: Monokai
    background = 272822
    foreground = F8F8F2
    cursor-color = F8F8F2
    selection-background = 49483E
    selection-foreground = F8F8F2

    # Colors (Monokai)
    palette = 0=#272822
    palette = 1=#F92672
    palette = 2=#A6E22E
    palette = 3=#F4BF75
    palette = 4=#66D9EF
    palette = 5=#AE81FF
    palette = 6=#A1EFE4
    palette = 7=#F8F8F2
    palette = 8=#75715E
    palette = 9=#F92672
    palette = 10=#A6E22E
    palette = 11=#F4BF75
    palette = 12=#66D9EF
    palette = 13=#AE81FF
    palette = 14=#A1EFE4
    palette = 15=#F9F8F5

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
    // Theme: Monokai
    theme "monokai"

    themes {
      monokai {
        fg "#F8F8F2"
        bg "#272822"
        black "#272822"
        red "#F92672"
        green "#A6E22E"
        yellow "#E6DB74"
        blue "#66D9EF"
        magenta "#AE81FF"
        cyan "#A1EFE4"
        white "#F8F8F2"
        orange "#FD971F"
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
