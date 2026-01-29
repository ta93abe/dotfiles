# dotfiles

**Nix** で管理するマルチプラットフォーム対応dotfiles

macOS、Linux（NixOS / 非NixOS）、WSL2 に対応した宣言的・再現可能な開発環境を構築します。

## 対応プラットフォーム

| プラットフォーム | 管理ツール | 状態 |
|-----------------|-----------|------|
| macOS (Apple Silicon) | nix-darwin + home-manager | ✅ |
| macOS (Intel) | nix-darwin + home-manager | ✅ |
| Linux (NixOS) | NixOS + home-manager | 🚧 テンプレート |
| Ubuntu | standalone home-manager | ✅ |
| WSL2 | standalone home-manager | ✅ |
| Windows | winget | ✅ |

---

## クイックスタート

### macOS

```bash
# 1. Nixをインストール（Determinate Systems推奨）
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. クローン
git clone https://github.com/ta93abe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3. 個人設定を作成
cp personal.nix.example personal.nix
vim personal.nix  # hostname, username, git設定を編集

# 4. 適用
nix run .#switch

# 5. Fishをデフォルトシェルに設定
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

### Linux（Ubuntu / WSL2）

```bash
# 1. Nixをインストール
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. クローン
git clone https://github.com/ta93abe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3. 個人設定を作成
cp personal.nix.example personal.nix
vim personal.nix  # hostname, username を編集
# WSL2の場合: isWSL = true; を追加

# 4. 適用
nix run .#switch-home

# 5. Fishをデフォルトシェルに設定
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

### Linux（NixOS）

```bash
# 1. dotfilesをクローン
git clone https://github.com/ta93abe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. 個人設定を作成
cp personal.nix.example personal.nix
vim personal.nix

# 3. マシン設定を作成
cp machines/nixos/example.nix machines/nixos/$(hostname).nix
# hardware-configuration.nixをインポート

# 4. flake.nixのnixosConfigurationsを有効化

# 5. 適用
sudo nixos-rebuild switch --flake .#hostname
```

### Windows + WSL2

```powershell
# === Windows側 ===

# 1. WSL2をインストール
wsl --install

# 2. dotfilesをクローン
git clone https://github.com/ta93abe/dotfiles.git
cd dotfiles\windows

# 3. wingetでパッケージをインストール
.\setup.ps1

# === WSL2側（Ubuntu）===
# 上記「Linux（非NixOS / WSL2）」の手順に従う
```

---

## 日常の使い方

### macOS

```bash
nix run .#switch   # 設定を適用
nix run .#build    # ビルドのみ（テスト）
nix run .#update   # flake inputsを更新
nix run .#list     # 全設定一覧表示
```

### Linux（Ubuntu / WSL2）

```bash
nix run .#switch-home   # 設定を適用
nix run .#build-home    # ビルドのみ（テスト）
nix run .#update        # flake inputsを更新
nix run .#list          # 全設定一覧表示
```

### Linux（NixOS）

```bash
nix run .#switch-nixos  # 設定を適用（要設定）
nix run .#build-nixos   # ビルドのみ（要設定）
nix run .#update        # flake inputsを更新
```

### ロールバック

```bash
# macOS
darwin-rebuild rollback

# NixOS
sudo nixos-rebuild switch --rollback

# home-manager
home-manager generations  # 世代一覧
home-manager switch --flake .#username@hostname  # 再適用
```

---

## プロジェクト構造

```
dotfiles/
├── flake.nix                    # エントリポイント（マルチシステム対応）
├── personal.nix                 # 個人設定（gitignored）
├── personal.nix.example         # 個人設定テンプレート
│
├── modules/
│   ├── common/
│   │   └── nix.nix             # Nix基本設定（共通）
│   ├── darwin/
│   │   ├── default.nix         # macOSエントリ
│   │   ├── system.nix          # Dock, Finder, Touch ID, キーボード
│   │   └── homebrew.nix        # Homebrew casks（GUIアプリ）
│   └── nixos/
│       └── default.nix         # NixOS共通設定
│
├── home/
│   ├── default.nix             # Home Managerエントリ
│   ├── packages.nix            # パッケージリスト（プラットフォーム分岐）
│   ├── xdg.nix                 # Ghostty, Zellij設定
│   └── programs/               # 各プログラム設定
│       ├── fish.nix
│       ├── git.nix
│       ├── starship.nix
│       ├── helix.nix
│       ├── fzf.nix
│       ├── zoxide.nix
│       ├── mcfly.nix
│       └── claude.nix
│
├── machines/
│   ├── darwin/                 # macOSマシン固有設定
│   │   └── ta93abe.nix
│   ├── nixos/                  # NixOSマシン固有設定
│   │   └── example.nix
│   └── linux/                  # 非NixOS Linux設定
│       ├── example.nix
│       ├── ubuntu.nix          # Ubuntu固有設定
│       └── wsl2.nix            # WSL2固有設定
│
├── lib/                        # ヘルパー関数
│   ├── default.nix
│   ├── mkDarwinSystem.nix
│   ├── mkNixosSystem.nix
│   └── mkHomeConfig.nix
│
└── windows/                    # Windows用（winget）
    ├── packages.json
    ├── setup.ps1
    └── README.md
```

---

## パッケージ管理

### Nix-First ポリシー

| カテゴリ | macOS | Linux | Windows |
|---------|-------|-------|---------|
| CLIツール | Nix (home-manager) | Nix (home-manager) | WSL2経由でNix |
| GUIアプリ | Homebrew Cask | nixpkgs / Flatpak | winget |
| システム設定 | nix-darwin | NixOS / 手動 | - |

### パッケージの追加

```bash
# 1. 検索
nix search nixpkgs <package>

# 2. 追加
#    共通: home/packages.nix の commonPackages
#    macOS専用: home/packages.nix の darwinPackages
#    Linux専用: home/packages.nix の linuxPackages

# 3. 適用
nix run .#switch       # macOS
nix run .#switch-home  # Linux/WSL2
```

### GUIアプリの追加（macOS）

```bash
# 1. modules/darwin/homebrew.nix の casks に追加
# 2. nix run .#switch
```

### GUIアプリの追加（Windows）

```powershell
# 1. パッケージIDを検索
winget search <name>

# 2. windows/packages.json に追加
# 3. winget import -i windows/packages.json
```

---

## 含まれるツール

### 共通（124個以上）

| カテゴリ | ツール |
|---------|--------|
| シェル | Fish, Starship, Zellij |
| エディタ | Helix |
| 検索 | ripgrep, fd, fzf, broot |
| Git | gh, gitui, tig, lefthook |
| 監視 | bottom, procs, bandwhich |
| データ処理 | jq, yq, xsv |
| ネットワーク | xh, dog, nmap, mtr |
| DB | pgcli, mycli, litecli, usql |
| K8s | k9s, helm, kubectx, stern |
| クラウド | awscli, azure-cli, gcloud |
| 言語 | Node.js, Python, Rust, Go, Zig, etc. |

### Linux専用

`xclip`, `wl-clipboard`, `inotify-tools`, `strace`, `htop`, `iotop`, `ncdu`, `duf`, etc.

### macOS専用

`cocoapods`, Homebrew Casksで管理するGUIアプリ

---

## テーマ

**Monokai** で統一:
- Ghostty（ターミナル）
- Zellij（ターミナルマルチプレクサ）
- Starship（プロンプト）
- Helix（エディタ）

---

## トラブルシューティング

### "experimental-features" エラー

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### 古い世代をクリーンアップ

```bash
# Nixストア全体
nix-collect-garbage -d

# home-managerの古い世代
home-manager expire-generations "-30 days"
```

### ビルドエラーの調査

```bash
# 詳細なエラー表示
nix run .#build 2>&1 | less       # macOS
nix run .#build-home 2>&1 | less  # Linux/WSL2

# 特定パッケージのビルド
nix build nixpkgs#<package> --show-trace
```

### WSL2でのNixインストール問題

```bash
# systemdが有効か確認
systemctl --version

# 有効でない場合、/etc/wsl.conf を作成
[boot]
systemd=true

# WSLを再起動
wsl --shutdown
```

---

## 新しいマシンの追加

### macOS

1. `machines/darwin/<hostname>.nix` を作成
2. `flake.nix` の `darwinConfigurations` に追加

### NixOS

1. `machines/nixos/<hostname>.nix` を作成
2. `hardware-configuration.nix` をインポート
3. `flake.nix` の `nixosConfigurations` に追加

### Ubuntu / WSL2

既存の設定（`ubuntu.nix`, `wsl2.nix`）を使用するか、カスタム設定を追加：

1. `machines/linux/<hostname>.nix` を作成（オプション）
2. `flake.nix` の `homeConfigurations` に追加
3. WSL2の場合は `personal.nix` に `isWSL = true;` を設定

---

## ライセンス

MIT
