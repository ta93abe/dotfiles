{ config, pkgs, personal, ... }:

{
  programs.git = {
    enable = true;
    userName = personal.git.userName;
    userEmail = personal.git.userEmail;

    # Delta (シンタックスハイライト付きdiff)
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "OneHalfDark";
      };
    };

    extraConfig = {
      # 基本設定
      init.defaultBranch = "main";
      pull.rebase = false;

      # カラー設定
      color.ui = "auto";

      # エディタ設定
      core.editor = "hx";

      # プッシュ設定
      push = {
        default = "simple";
        autoSetupRemote = true;
      };

      # マージ設定
      merge.conflictstyle = "diff3";

      # Rebase設定
      rebase.autoStash = true;

      # Fetch設定
      fetch.prune = true;

      # Diff設定
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };
    };

    # Git aliases
    aliases = {
      st = "status";
      sw = "switch";
      rs = "restore";
      br = "branch";
      ci = "commit";
      unstage = "restore --staged";
      last = "log -1 HEAD";
      lg = "log --graph --oneline --decorate --all";
      amend = "commit --amend --no-edit";
    };

    # グローバル ignore設定
    ignores = [
      ".DS_Store"
      "*.swp"
      "*.swo"
      "*~"
      ".vscode/"
      ".idea/"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
    ];
  };
}
