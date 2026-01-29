# Claude Code global settings
{ config, pkgs, lib, ... }:

{
  home.file.".claude/settings.json".text = builtins.toJSON {
    permissions = {
      allow = [
        "Bash(pnpm cf:build:*)"
      ];
      defaultMode = "default";
    };
    statusLine = {
      type = "command";
      command = ''input=$(cat); git_branch=$(git -c core.fileMode=false -c gc.autodetach=false branch --show-current 2>/dev/null || echo 'no-git'); current_dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir')"); usage=$(echo "$input" | jq '.context_window.current_usage'); if [ "$usage" != "null" ]; then current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens'); size=$(echo "$input" | jq '.context_window.context_window_size'); context_pct=$((current * 100 / size)); context_display="${context_pct}%"; else context_display="0%"; fi; model=$(echo "$input" | jq -r '.model.display_name'); printf '%s %s %s %s' "$git_branch" "$current_dir" "$context_display" "$model"'';
    };
    enabledPlugins = {
      "rust-analyzer-lsp@claude-plugins-official" = true;
      "code-simplifier@claude-plugins-official" = true;
      "github@claude-plugins-official" = true;
      "playwright@claude-plugins-official" = true;
      "frontend-design@claude-plugins-official" = true;
      "commit-commands@claude-plugins-official" = true;
      "code-review@claude-plugins-official" = true;
      "feature-dev@claude-plugins-official" = true;
      "pr-review-toolkit@claude-plugins-official" = true;
    };
    language = "日本語";
  };
}
