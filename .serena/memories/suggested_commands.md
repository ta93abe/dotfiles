# 推奨コマンド

## 日常的な使用

### 設定の適用
```bash
# .nixファイルを編集した後
nix run .#switch
```

### パッケージの更新
```bash
# flake inputsを更新
nix run .#update

# 更新されたパッケージでリビルド
nix run .#switch
```

### 適用せずにビルドのみ（テスト）
```bash
nix run .#build
```

## パッケージ検索

```bash
# nixpkgsでパッケージを検索
nix search nixpkgs <パッケージ名>
```

## トラブルシューティング

### デバッグ付きでビルド
```bash
darwin-rebuild --show-trace switch --flake .
```

### 前の世代にロールバック
```bash
darwin-rebuild rollback
```

### インストール済みパッケージをリスト
```bash
nix-env -q
```

## メンテナンス

### 古い世代をクリーンアップ
```bash
# 世代をリスト
nix-env --list-generations

# 古い世代を削除（最新5つを保持）
nix-env --delete-generations +5

# ガベージコレクション
nix-collect-garbage -d

# ストアを最適化
nix-store --optimise
```

### ディスク使用量を確認
```bash
nix path-info -rsSh /run/current-system | sort -k2 -h
```

### フレッシュな状態にリセット
```bash
sudo nix-collect-garbage -d
nix run .#switch
```

## Graphite (gt) 操作

```bash
# ブランチ作成とコミット
gt create -m "feat: 新機能の追加"

# PRの提出
gt submit --no-interactive

# スタックの同期
gt sync
```

## シェル関連

```bash
# Fishシェルを再読み込み
exec fish

# シェルを確認
echo $SHELL
```

## Homebrew（GUIアプリのみ）

```bash
# インストール済みcaskをリスト
brew list --cask
```
