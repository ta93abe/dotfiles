# スタイルとコンベンション

## Nixコードスタイル

### ファイル構造
- 各プログラムの設定は個別ファイルに分離
- `home/programs/` にプログラムごとのモジュールを配置
- インポートは `home.nix` で一元管理

### コメント
- セクション区切りには `=` を使った横線コメントを使用
```nix
# =============================================================================
# セクション名
# =============================================================================
```
- 重要な説明には通常のコメントを使用

### フォーマット
- インデント: スペース2つ
- 属性セットは `{ ... }` で囲む
- リストは `[ ... ]` で囲む
- `with pkgs;` を使用してパッケージ名を簡略化

### 命名規則
- ファイル名: ケバブケース（例: `darwin-configuration.nix`）
- 変数名: キャメルケース
- 属性名: ドットで区切る（例: `programs.git.enable`）

## モジュールパターン

### 基本構造
```nix
{ config, pkgs, ... }:

{
  # 設定内容
}
```

### 個人設定の参照
```nix
{ config, pkgs, personal, ... }:

{
  programs.git.userName = personal.git.userName;
}
```

## Nix-Firstポリシー

### パッケージ追加の優先順位
1. **CLIツール**: `home/packages.nix` にNixパッケージを追加
2. **システムパッケージ**: `darwin-configuration.nix` の `environment.systemPackages` に追加
3. **GUIアプリ**: nixpkgsにない場合のみ `darwin-configuration.nix` の `homebrew.casks` に追加

### 避けるべきこと
- Homebrew経由でのCLIツールのインストール
- 直接的なHomebrewコマンドでのパッケージ管理

## テーマ

### Tokyo Night
- Ghostty
- fzf
- Zellij

### Monokai
- Starship（カスタムプロンプト🎣）
- Helix
