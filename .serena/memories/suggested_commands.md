# 推奨コマンド

## 日常的な使用

### 設定の適用
```bash
# .nixファイルを編集した後
darwin-rebuild switch --flake .
```

### パッケージの更新
```bash
# flake inputsを更新
nix flake update

# 更新されたパッケージでリビルド
darwin-rebuild switch --flake .
```

### 適用せずにビルドのみ（テスト）
```bash
darwin-rebuild build --flake .
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
darwin-rebuild switch --flake . --recreate-lock-file
```

## Git操作

```bash
git status
git diff
git add .
git commit -m "メッセージ"
git push
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
