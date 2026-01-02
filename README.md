# dotfiles

**nix-darwin** と **home-manager** で管理する個人用dotfiles

## 哲学：Nix-Firstアプローチ

この構成では、HomebrewよりもNixパッケージを優先します：

- ✅ **CLIツール**: 100% Nixで管理（`home.nix`）
- ✅ **システムパッケージ**: Nixで管理（`darwin-configuration.nix`）
- ⚠️ **GUIアプリ**: Homebrew Caskで管理（nixpkgsで利用できない場合のみ）

**Nixを使う理由：**
- 宣言的で再現可能
- アトミックなアップグレードとロールバック
- 隔離されたパッケージ環境
- 依存関係の競合がない

## 前提条件

- macOS
- flakeサポート付きの[Nixパッケージマネージャー](https://nixos.org/download.html)

### Nixのインストール

```bash
sh <(curl -L https://nixos.org/nix/install)
```

## セットアップガイド

### ステップ 1: Nixパッケージマネージャーのインストール

flakeサポート付きでNixをインストール：

```bash
# Nixをインストール（公式インストーラー）
sh <(curl -L https://nixos.org/nix/install)

# シェルを再起動
exec $SHELL

# インストール確認
nix --version
```

**期待される出力**: `nix (Nix) 2.x.x`

### ステップ 2: このリポジトリをクローン

```bash
# 任意の場所にクローン
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### ステップ 3: 個人設定の作成

**個人設定ファイルを作成：**

```bash
# テンプレートをコピー
cp personal.nix.example personal.nix
```

**システム情報を取得：**

```bash
# ホスト名を取得
scutil --get ComputerName
# 例: "MacBook-Pro"

# ユーザー名を取得
whoami
# 例: "john"
```

**`personal.nix` を編集：**

```nix
{
  # システム設定
  hostname = "MacBook-Pro";  # ← 実際のホスト名
  username = "john";         # ← 実際のユーザー名

  # Git設定
  git = {
    userName = "John Doe";              # ← あなたの名前
    userEmail = "john@example.com";     # ← あなたのメールアドレス
  };
}
```

**重要な注意事項：**
- `personal.nix` はgitignoreされており、コミットされません
- 他のマシン用のテンプレートとして `personal.nix.example` を保持してください
- Intel Macを使用している場合は、`flake.nix` の27行目のアーキテクチャを更新してください（`x86_64-darwin`）

### ステップ 4: 初期ビルドと適用

**初回インストール：**

```bash
# 設定をビルド（10〜30分かかる場合があります）
# ホスト名はpersonal.nixファイルから読み込まれます
nix build .#darwinConfigurations.$(nix eval --raw .#darwinConfigurations --apply 'x: builtins.head (builtins.attrNames x)').system

# または、ホスト名を直接指定（personal.nixから）
nix build .#darwinConfigurations.YOUR-HOSTNAME.system

# 設定を適用
./result/sw/bin/darwin-rebuild switch --flake .

# Fishをデフォルトシェルに設定
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

**ビルド中に起こること：**
- 124個以上のCLIツールをダウンロード
- プログラミング言語をダウンロード
- システム設定を構成
- GUIアプリ用のHomebrewをセットアップ
- Fishシェルを構成

### ステップ 5: ターミナルを再起動

```bash
# ターミナルを再起動、または実行
exec fish

# インストール確認
which helix   # nixストアパスが表示されるはず
which fzf     # nixストアパスが表示されるはず
starship --version  # 動作するはず
```

### ステップ 6: インストール後の確認

**すべてが動作することを確認：**

```bash
# モダンなCLIツールをテスト
eza -la       # 改良版ls
bat README.md # 改良版cat
rg "nix"      # 改良版grep

# シェル統合をテスト
zoxide --version  # スマートcd
mcfly --version   # 履歴検索

# Kubernetesツールをテスト（使用している場合）
k9s version
helm version

# データベースツールをテスト
usql --version
```

**Homebrew GUIアプリを確認：**

```bash
# インストール済みcaskをリスト
brew list --cask

# 表示されるべきもの: chrome, firefox, dockerなど
```

## システムの更新

### 日常的な使用

**設定変更を適用：**

```bash
cd ~/.dotfiles

# .nixファイルを編集した後
darwin-rebuild switch --flake .
```

**パッケージを更新：**

```bash
# flake inputsを更新
nix flake update

# 更新されたパッケージでリビルド
darwin-rebuild switch --flake .
```

### 新しいパッケージの追加

**1. パッケージを検索：**

```bash
nix search nixpkgs ripgrep
```

**2. `home.nix` に追加：**

```nix
packages = with pkgs; [
  # ... 既存のパッケージ
  your-new-package
];
```

**3. 適用：**

```bash
darwin-rebuild switch --flake .
```

### パッケージの削除

**1. `home.nix` から削除**

**2. 適用してクリーンアップ：**

```bash
darwin-rebuild switch --flake .
nix-collect-garbage -d
```

## 含まれるもの

### システム設定（darwin-configuration.nix）- Nix管理

- macOSシステムデフォルト（Dock、Finder、キーボード設定）
- sudo用のTouch ID
- Nerd Fonts（FiraCode、JetBrainsMono、Hackなど）via Nix
- システムパッケージ（データベース、DevOpsツールなど）via Nix
- 最小限のHomebrew統合（GUIアプリのみ）

### ユーザー設定（home.nix）- 100% Nix

- **124個以上のCLIツール** - すべてNixで管理：
  - モダンなUnixツール（bat、eza、ripgrep、fdなど）
  - Gitツール（delta、gitui、ghなど）
  - 開発ツール（helix、zellijなど）
  - システム監視（bottom、procs、bandwhichなど）
  - **クラウドCLI**（AWS、Azure、GCP、Firebase、Fly.io）via Nix
  - **DevOpsツール**（CircleCIなど）via Nix
  - **Pythonツール**（uv - モダンなパッケージマネージャー）via Nix
  - **モバイル開発**（CocoaPods）via Nix
- プログラミング言語（Node.js、Python、Rust、Go、Zig、Juliaなど）via Nix
- Delta統合付きGit設定
- Fish shellの設定：
  - シンタックスハイライト
  - オートコンプリート
  - モダンなエイリアス
  - Zoxide統合
  - fzfキーバインド
- Starshipプロンプト
- Helixエディタ設定
- Ghosttyターミナル設定（Tokyo Nightテーマ）
- Zellij設定（Vim風キーバインド）
- fzf設定（詳細なカラースキームとプレビュー）

### Homebrew（最小限の使用）

**nixpkgsで利用できないGUIアプリケーションのみ：**

- ブラウザ、IDE、デザインツール
- macOS固有のGUIアプリケーション
- **Homebrew経由のCLIツールはゼロ** - すべてのCLIツールはNixを使用
- リストにないパッケージの自動クリーンアップ

## パッケージ管理

### Nix-Firstポリシー

**常にHomebrewよりもNixを優先：**

1. **CLIツールの場合**: `home.nix` のパッケージリストに追加
2. **システムパッケージの場合**: `darwin-configuration.nix` のenvironment.systemPackagesに追加
3. **GUIアプリの場合**: nixpkgsで利用できない場合のみ、`darwin-configuration.nix` のHomebrew casksを使用

その後、`darwin-rebuild switch --flake .` を実行して変更を適用します。

### 新しいパッケージの追加

**ステップ 1: nixpkgsでパッケージを検索**

```bash
# nixpkgsを検索
nix search nixpkgs <パッケージ名>

# 例
nix search nixpkgs ripgrep
```

**ステップ 2: 適切な設定ファイルに追加**

CLIツールの場合（最も一般的）：
```nix
# home.nix
packages = with pkgs; [
  # ... 既存のパッケージ
  your-new-package
];
```

GUIアプリの場合（最後の手段）：
```nix
# darwin-configuration.nix
homebrew.casks = [
  # ... 既存のcasks
  "your-gui-app"
];
```

**ステップ 3: 変更を適用**

```bash
darwin-rebuild switch --flake .
```

### Homebrewからの移行

Homebrewから移行する場合：

1. **CLIツール**: ✅ すべて`home.nix`のNixに移行済み
2. **GUIアプリ**: `darwin-configuration.nix`でHomebrew casksを介して管理
3. **クリーンアップ**: 設定にないHomebrewパッケージは`cleanup = "zap"`で自動削除

```bash
# 設定を適用 - これによりNixとHomebrewの両方が管理されます
darwin-rebuild switch --flake .

# オプション: Homebrewがまだ管理しているものをリスト
brew list --cask
```

## トラブルシューティング

### よくある問題

#### 問題 1: "experimental-features" エラー

**エラー：**
```
error: experimental Nix feature 'nix-command' is disabled
```

**解決策：**
```bash
# nix設定を作成/編集
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

#### 問題 2: "permission denied" でビルドが失敗

**解決策：**
```bash
# Nixが適切にインストールされていることを確認
sudo nix-daemon
# または再起動
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

#### 問題 3: Homebrewの競合

**エラー：**
```
Warning: formula/cask is already installed
```

**解決策：**
```bash
# nix-darwinに管理させる
darwin-rebuild switch --flake .

# まだ競合する場合は、手動でアンインストール
brew uninstall --cask <app-name>
```

#### 問題 4: Fishシェルがアクティブにならない

**解決策：**
```bash
# fishが許可されたシェルにあるか確認
cat /etc/shells | grep fish

# ない場合は追加
echo $(which fish) | sudo tee -a /etc/shells

# シェルを変更
chsh -s $(which fish)

# ログアウトして再度ログイン
```

#### 問題 5: リビルドが遅い

**解決策：**
```bash
# バイナリキャッシュを使用
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update

# またはmax-jobsでリビルド
darwin-rebuild switch --flake . --max-jobs auto
```

### メンテナンスコマンド

**古い世代をクリーンアップ：**

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

**フレッシュな状態にリセット：**

```bash
# すべての古い世代を削除
sudo nix-collect-garbage -d

# スクラッチからリビルド
darwin-rebuild switch --flake . --recreate-lock-file
```

**ディスク使用量を確認：**

```bash
# ストアパスとサイズを表示
nix path-info -rsSh /run/current-system | sort -k2 -h
```

### ヘルプ

- **Nixマニュアル**: https://nixos.org/manual/nix/stable/
- **nix-darwin**: https://github.com/LnL7/nix-darwin
- **Home Manager**: https://nix-community.github.io/home-manager/
- **パッケージ検索**: https://search.nixos.org/packages

### 便利なコマンドリファレンス

```bash
# 現在の設定を表示
darwin-rebuild --show-trace switch --flake .

# 前の世代にロールバック
darwin-rebuild rollback

# インストール済みパッケージをリスト
nix-env -q

# パッケージの詳細を確認
nix-info

# 適用せずに設定をテスト
darwin-rebuild build --flake .
```

## テーマとカラースキーム

すべてのツールは **Tokyo Night** テーマで統一されています：

- 🎨 **Ghostty**: Tokyo Nightカラーパレット
- 🔍 **fzf**: Tokyo Nightカラースキーム + batプレビュー
- 🎣 **Starship**: カスタムプロンプト（🎣アイコン）
- 📝 **Helix**: Monokaiテーマ
- 🪟 **Zellij**: Tokyo Nightテーマ + Vim風キーバインド

## ライセンス

MIT
