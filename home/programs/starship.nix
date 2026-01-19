{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;

      # Monokai color palette
      palette = "monokai";
      palettes.monokai = {
        foreground = "#F8F8F2";
        background = "#272822";
        red = "#F92672";
        green = "#A6E22E";
        yellow = "#E6DB74";
        orange = "#FD971F";
        blue = "#66D9EF";
        purple = "#AE81FF";
        gray = "#75715E";
      };

      character = {
        success_symbol = "[🎣](blue)";
        error_symbol = "[✖](bold red) ";
      };

      directory = {
        truncation_length = 7;
        truncation_symbol = ".../";
        format = "[$path]($style)[$lock_symbol]($lock_style) ";
        style = "bold blue";
      };

      battery = {
        full_symbol = "🔋";
        charging_symbol = "🔌";
        discharging_symbol = "⚡";
        display = [{
          threshold = 30;
          style = "bold red";
        }];
      };

      cmd_duration = {
        min_time = 10000;
        format = " took [$duration]($style)";
        style = "yellow";
      };

      git_branch = {
        format = " [$symbol$branch]($style) ";
        symbol = "🍣 ";
        style = "bold green";
      };

      git_commit = {
        commit_hash_length = 8;
        style = "bold purple";
      };

      git_state = {
        format = "[($state( $progress_current of $progress_total))]($style) ";
        style = "orange";
      };

      git_status = {
        conflicted = "⚔️ ";
        ahead = "🏎️ 💨 ×\${count}";
        behind = "🐢 ×\${count}";
        diverged = "🔱 🏎️ 💨 ×\${ahead_count} 🐢 ×\${behind_count}";
        untracked = "🛤️  ×\${count}";
        stashed = "📦 ";
        modified = "📝 ×\${count}";
        staged = "🗃️  ×\${count}";
        renamed = "📛 ×\${count}";
        deleted = "🗑️  ×\${count}";
        style = "red";
        format = "$all_status$ahead_behind";
      };

      hostname = {
        ssh_only = false;
        format = "<[$hostname]($style)>";
        trim_at = "-";
        style = "bold gray";
        disabled = true;
      };

      julia = {
        format = "[$symbol$version]($style) ";
        symbol = "ஃ ";
        style = "bold purple";
      };

      memory_usage = {
        format = "$symbol[\${ram}( | \${swap})]($style) ";
        threshold = 70;
        style = "bold orange";
        disabled = true;
      };

      package = {
        disabled = true;
      };

      python = {
        format = "[$symbol$version]($style) ";
        style = "bold yellow";
      };

      rust = {
        format = "[$symbol$version]($style) ";
        style = "bold orange";
      };

      nodejs = {
        format = "[$symbol$version]($style) ";
        style = "bold green";
      };

      golang = {
        format = "[$symbol$version]($style) ";
        style = "bold blue";
      };

      time = {
        time_format = "%T";
        format = "🕙 $time($style) ";
        style = "gray";
        disabled = true;
      };

      username = {
        style_user = "bold purple";
        show_always = false;
      };
    };
  };
}
