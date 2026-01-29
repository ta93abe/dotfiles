# Claude Code custom commands
{ config, pkgs, lib, ... }:

{
  home.file.".claude/commands/codex-review.md".text = ''
    ---
    description: OpenAI Codex CLIにコードレビューを依頼する
    argument-hint: [対象 (省略時: unstaged changes)]
    allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(codex:*)
    ---

    # Codex Review

    OpenAI Codex CLIを使用してコードレビューを実行します。

    ## 手順

    1. まずレビュー対象を特定する:
       - 引数がない場合: `git diff` でunstaged changesを取得
       - 引数が `--staged` の場合: `git diff --staged` でstaged changesを取得
       - 引数がブランチ名の場合: `git diff <branch>...HEAD` でブランチ差分を取得
       - 引数がファイルパスの場合: そのファイルの内容を取得

    2. `codex` コマンドを実行してレビューを依頼:

    ```bash
    codex "以下のコード変更をレビューしてください。バグ、セキュリティ問題、パフォーマンス問題、コード品質の観点から確認し、改善提案があれば教えてください。日本語で回答してください。

    <変更内容>
    (diff内容をここに挿入)
    </変更内容>"
    ```

    3. Codexの出力をそのまま表示する

    ## 引数の解釈

    - `$ARGUMENTS` が空: unstaged changes をレビュー
    - `$ARGUMENTS` が `--staged`: staged changes をレビュー
    - `$ARGUMENTS` が `main` や `develop` などのブランチ名: そのブランチからの差分をレビュー
    - `$ARGUMENTS` がファイルパス: そのファイルをレビュー

    ## 実行例

    ```
    /codex-review                    # unstaged changesをレビュー
    /codex-review --staged           # staged changesをレビュー
    /codex-review main               # mainブランチからの差分をレビュー
    /codex-review src/pages/index.astro  # 特定ファイルをレビュー
    ```

    ## 注意

    - Codex CLIが必要です（`home/packages.nix`に追加済み、または`nix run nixpkgs#openai-codex`で実行可能）
    - OpenAI APIキーが設定されている必要があります
  '';
}
