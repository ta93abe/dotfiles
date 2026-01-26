# Windows Setup

Windows環境のセットアップ用ファイル。wingetを使ってパッケージを宣言的に管理。

## 使い方

### 初回セットアップ

PowerShellを管理者として実行:

```powershell
cd windows
.\setup.ps1
```

### パッケージの追加

1. `packages.json` にパッケージを追加
2. `winget import -i packages.json` を実行

### 現在のパッケージをエクスポート

```powershell
winget export -o packages.json
```

## WSL2 セットアップ

Windows側のセットアップ後、WSL2でLinux環境を構築:

```powershell
# WSL2のインストール
wsl --install

# Ubuntu（デフォルト）が起動したら、Nixをインストール
curl -L https://nixos.org/nix/install | sh

# dotfilesをクローン
git clone https://github.com/ta93abe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# home-managerで設定を適用
home-manager switch --flake .#username@hostname
```

## パッケージID検索

```powershell
winget search <name>
```

## 構成

```
windows/
├── packages.json   # wingetパッケージリスト
├── setup.ps1       # セットアップスクリプト
└── README.md       # このファイル
```
