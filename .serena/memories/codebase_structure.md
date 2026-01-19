# コードベース構造

```
dotfiles/
├── flake.nix                 # Nixフレークのエントリポイント（inputs/outputs定義）
├── darwin-configuration.nix  # システム設定（macOS defaults, Homebrew, fonts）
├── home.nix                  # Home Managerのエントリポイント（モジュールインポート）
├── personal.nix              # 個人設定（gitignored）- ホスト名、ユーザー名、git設定
├── personal.nix.example      # personal.nixのテンプレート
├── README.md                 # プロジェクトドキュメント
│
├── home/                     # Home Manager設定（モジュール化）
│   ├── packages.nix          # パッケージリスト（124個以上のCLIツール）
│   ├── xdg.nix               # XDG設定（Ghostty, Zellij）
│   └── programs/             # 個別プログラム設定
│       ├── fish.nix          # Fishシェル設定
│       ├── git.nix           # Git設定（delta統合）
│       ├── starship.nix      # Starshipプロンプト
│       ├── helix.nix         # Helixエディタ
│       ├── fzf.nix           # fzf設定
│       ├── zoxide.nix        # zoxide設定
│       └── mcfly.nix         # mcfly設定
│
├── machines/                 # マシン固有の設定
│   └── {hostname}.nix        # ホスト名ごとの設定ファイル
│
├── lib/                      # ユーティリティ関数
│   └── mkSystem.nix          # システム生成ヘルパー
│
├── docs/                     # ドキュメント
│
├── .github/                  # GitHub設定
│   └── workflows/
│       ├── claude.yml        # Claude Code ワークフロー
│       └── claude-code-review.yml
│
└── .claude/                  # Claude Code設定
    └── settings.local.json
```

## ファイルの役割

### エントリポイント
- `flake.nix`: Nixフレークの定義、依存関係、outputs
- `darwin-configuration.nix`: macOSシステム設定とHomebrew
- `home.nix`: Home Managerの統合ポイント

### モジュール構造
設定は`home/programs/`に分割され、個別プログラムごとにファイルが分かれている。
この構造により：
- 変更の影響範囲が明確
- コードレビューが容易
- 再利用性が高い
