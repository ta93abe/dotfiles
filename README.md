# dotfiles

**nix-darwin** と **home-manager** で管理する個人用dotfiles

## セットアップ

```bash
# 1. Nixをインストール
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. クローン
git clone https://github.com/ta93abe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3. 個人設定を作成
cp personal.nix.example personal.nix
# personal.nix を編集（hostname, username, git設定）

# 4. 適用（初回）
sudo nix run nix-darwin -- switch --flake .

# 5. Fishをデフォルトシェルに
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

## 日常の使い方

```bash
nix run .#switch  # 設定を適用
nix run .#build   # ビルドのみ（テスト）
nix run .#update  # パッケージを更新
```

## 哲学：Nix-Firstアプローチ

- **CLIツール**: 100% Nixで管理（`home/packages.nix`）
- **システム設定**: Nixで管理（`darwin-configuration.nix`）
- **GUIアプリ**: Homebrew Caskで管理（nixpkgsで利用できない場合のみ）

## 構造

```
dotfiles/
├── flake.nix                 # エントリポイント
├── darwin-configuration.nix  # macOSシステム設定
├── home.nix                  # Home Managerエントリポイント
├── personal.nix              # 個人設定（gitignored）
├── home/
│   ├── packages.nix          # パッケージリスト
│   ├── xdg.nix               # Ghostty, Zellij設定
│   └── programs/             # 各プログラム設定
└── machines/                 # マシン固有設定
```

## パッケージの追加

```bash
# 1. 検索
nix search nixpkgs <package>

# 2. home/packages.nix に追加

# 3. 適用
nix run .#switch
```

## トラブルシューティング

### "experimental-features" エラー

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### 古い世代をクリーンアップ

```bash
nix-collect-garbage -d
```

### ロールバック

```bash
darwin-rebuild rollback
```

## テーマ

**Tokyo Night** で統一:
- Ghostty
- fzf
- Zellij

**Monokai**:
- Starship
- Helix

## ライセンス

MIT
