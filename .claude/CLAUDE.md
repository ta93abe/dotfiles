# dotfiles

nix-darwin と home-manager で管理するmacOS用dotfiles。Nix-Firstアプローチで宣言的・再現可能な開発環境を構築。

## 技術スタック

| カテゴリ | 技術 |
|---------|------|
| 言語 | Nix |
| システム設定 | nix-darwin |
| ユーザー設定 | home-manager |
| パッケージ | nixpkgs-24.11-darwin / nixpkgs-unstable |
| シェル | Fish |
| エディタ | Helix |
| ターミナル | Ghostty |
| テーマ | Tokyo Night |
| Issue管理 | Linear (ta93abe team / dotfiles project) |
| PR管理 | Graphite (gt CLI) |

## プロジェクト構造

```
dotfiles/
├── flake.nix                 # Nixフレークのエントリポイント
├── darwin-configuration.nix  # システム設定（macOS defaults, Homebrew, fonts）
├── home.nix                  # Home Managerのエントリポイント
├── personal.nix              # 個人設定（gitignored）
├── personal.nix.example      # personal.nixのテンプレート
├── home/
│   ├── packages.nix          # パッケージリスト（124個以上のCLIツール）
│   ├── xdg.nix               # XDG設定（Ghostty, Zellij）
│   └── programs/             # 個別プログラム設定
│       ├── fish.nix
│       ├── git.nix
│       ├── starship.nix
│       ├── helix.nix
│       ├── fzf.nix
│       ├── zoxide.nix
│       └── mcfly.nix
├── machines/                 # マシン固有の設定
│   └── {hostname}.nix
└── lib/
    └── mkSystem.nix          # ユーティリティ関数
```

## 開発コマンド

| コマンド | 説明 |
|---------|------|
| `nix run .#switch` | 設定を適用 |
| `nix run .#build` | ビルドのみ（テスト） |
| `nix run .#update` | パッケージを更新 |
| `darwin-rebuild rollback` | 前の世代に戻す |
| `nix search nixpkgs <name>` | パッケージを検索 |

## ワークフローツール

### 重要: GitHub はデータベースとして扱う

このプロジェクトでは GitHub をコードリポジトリとしてのみ使用し、以下のツールでワークフローを管理します：

| 用途 | ツール | 備考 |
|------|--------|------|
| Issue管理 | **Linear** | ta93abe team / dotfiles project |
| PR管理 | **Graphite (gt)** | スタック型PRワークフロー |
| コード管理 | GitHub | データベースとして使用 |

### Linear (Issue管理)

- **チーム**: ta93abe
- **プロジェクト**: dotfiles
- Issue の作成・更新・クローズは Linear で行う
- GitHub Issues は使用しない

### Graphite (PR管理)

`git` の代わりに `gt` コマンドを使用してPRを管理します。

```bash
# ブランチ作成とコミット
gt create -m "feat: 新機能の追加"

# PRの提出（スタック全体）
gt submit --no-interactive

# スタックの状態確認
gt state

# 上下のブランチに移動
gt up / gt down

# リベース・同期
gt sync
gt restack
```

**重要**: `git commit` や `git push` ではなく、`gt create` と `gt submit` を使用すること。

## ブランチ戦略

### Graphite (gt) を使用してブランチを管理

```bash
# 新機能開発の場合
gt create -m "feat: 機能の説明"

# バグ修正の場合
gt create -m "fix: 修正の説明"

# ドキュメント更新の場合
gt create -m "docs: 更新の説明"
```

### ワークフロー

1. **開発**: main ブランチ上でコードを書く
2. **ブランチ作成+コミット**: `gt create -m "feat: 説明"` でブランチ作成とコミットを同時に行う
3. **PR提出**: `gt submit --no-interactive` でPRを作成・更新
4. **レビュー**: Graphite または GitHub でコードレビュー
5. **マージ**: Graphite でマージ
6. **同期**: `gt sync` で最新の main を取得し、古いブランチを削除

### コミットメッセージ

Conventional Commits に従う:
- `feat:` 新機能
- `fix:` バグ修正
- `docs:` ドキュメント
- `refactor:` リファクタリング
- `chore:` その他

## Nix-First ポリシー

パッケージ追加の優先順位:
1. **CLIツール**: `home/packages.nix` にNixパッケージを追加
2. **システムパッケージ**: `darwin-configuration.nix` の `environment.systemPackages` に追加
3. **GUIアプリ**: nixpkgsにない場合のみ `darwin-configuration.nix` の `homebrew.casks` に追加

## タスク完了時チェックリスト

1. `nix run .#build` でビルド確認
2. `nix run .#switch` で設定適用
3. 動作確認
4. `gt create -m "type: 説明"` でコミット
5. `gt submit --no-interactive` でPR作成
