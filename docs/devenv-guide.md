# devenv ガイド

devenvは、Nixベースのモダンな開発環境管理ツールです。direnvの代替として、より宣言的で再現性の高い開発環境を提供します。

## 基本的な使い方

### 1. プロジェクトの初期化

```bash
cd your-project
devenv init
```

これにより、`devenv.nix` と `devenv.yaml` が作成されます。

### 2. devenv.nix の設定例

#### Python プロジェクト
```nix
{ pkgs, ... }: {
  # 使用する言語の有効化
  languages.python = {
    enable = true;
    version = "3.11";
  };

  # 環境変数
  env.DATABASE_URL = "postgres://localhost/mydb";
  env.DEBUG = "true";

  # 追加パッケージ
  packages = with pkgs; [
    git
    postgresql
  ];

  # プロジェクト起動時のスクリプト
  enterShell = ''
    echo "Python development environment loaded!"
    python --version
  '';

  # サービス（データベースなど）
  services.postgres = {
    enable = true;
    listen_addresses = "127.0.0.1";
  };
}
```

#### Node.js プロジェクト
```nix
{ pkgs, ... }: {
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_20;
  };

  packages = with pkgs; [
    nodePackages.pnpm
  ];

  env.NODE_ENV = "development";

  enterShell = ''
    echo "Node.js $(node --version) environment loaded!"
  '';
}
```

#### Go プロジェクト
```nix
{ pkgs, ... }: {
  languages.go = {
    enable = true;
    package = pkgs.go_1_21;
  };

  env.GOPATH = "${config.env.DEVENV_ROOT}/.go";
  env.CGO_ENABLED = "1";

  packages = with pkgs; [
    gotools
    gopls
  ];
}
```

#### Rust プロジェクト
```nix
{ pkgs, ... }: {
  languages.rust = {
    enable = true;
    channel = "stable";
  };

  packages = with pkgs; [
    cargo-watch
    rust-analyzer
  ];

  enterShell = ''
    echo "Rust $(rustc --version) environment loaded!"
  '';
}
```

### 3. 開発環境に入る

```bash
# シェルに入る
devenv shell

# コマンドを実行
devenv shell -- python script.py

# サービスを起動（PostgreSQLなど）
devenv up
```

### 4. Fish shell 統合（推奨）

Fish を使用している場合、プロジェクトディレクトリに入った時に自動で環境を読み込むことができます：

```fish
# ~/.config/fish/config.fish に追加
function devenv_auto_load --on-variable PWD
    if test -f devenv.nix
        devenv shell
    end
end
```

## よく使う機能

### スクリプト/タスクの定義

```nix
{ pkgs, ... }: {
  scripts = {
    # カスタムスクリプト
    hello.exec = "echo Hello from devenv!";

    # 複数行のスクリプト
    test.exec = ''
      echo "Running tests..."
      pytest tests/
    '';
  };
}
```

使い方：
```bash
devenv shell
hello  # "Hello from devenv!" が表示される
test   # テストが実行される
```

### 複数言語のプロジェクト

```nix
{ pkgs, ... }: {
  languages.python.enable = true;
  languages.javascript.enable = true;
  languages.go.enable = true;

  # 必要なツールを追加
  packages = with pkgs; [
    docker-compose
    kubectl
  ];
}
```

### 環境変数の設定

```nix
{ pkgs, ... }: {
  env = {
    DATABASE_URL = "postgres://localhost/mydb";
    API_KEY = "dev-key-12345";
    LOG_LEVEL = "debug";
  };

  # .envファイルからも読み込める
  dotenv.enable = true;
}
```

### Pre-commit hooks

```nix
{ pkgs, ... }: {
  pre-commit.hooks = {
    nixpkgs-fmt.enable = true;
    shellcheck.enable = true;
    prettier.enable = true;
  };
}
```

## direnv との違い

| 機能 | direnv | devenv |
|------|--------|--------|
| 設定ファイル | `.envrc` (shell) | `devenv.nix` (Nix) |
| 環境変数 | ✅ | ✅ |
| ツールバージョン管理 | ❌ (別途 asdf 必要) | ✅ |
| サービス起動 | ❌ | ✅ (PostgreSQL, Redis など) |
| 再現性 | 中 | 高 (Nix ベース) |
| スクリプト/タスク | ❌ | ✅ |

## 便利なコマンド

```bash
# 環境情報を表示
devenv info

# プロセス一覧
devenv processes

# サービスのログ
devenv logs

# 設定をテスト
devenv test

# クリーンアップ
devenv gc
```

## トラブルシューティング

### 環境が読み込まれない
```bash
# キャッシュをクリア
rm -rf .devenv
devenv shell
```

### サービスが起動しない
```bash
# ログを確認
devenv logs

# 個別に起動
devenv up postgres
```

## 参考リンク

- [devenv公式ドキュメント](https://devenv.sh/)
- [Language Support](https://devenv.sh/languages/)
- [Services](https://devenv.sh/services/)
- [Pre-commit Hooks](https://devenv.sh/pre-commit-hooks/)
