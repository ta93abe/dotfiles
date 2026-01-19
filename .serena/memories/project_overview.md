# プロジェクト概要

## 目的
macOS用のdotfiles管理プロジェクト。**nix-darwin** と **home-manager** を使用して、宣言的で再現可能な開発環境を構築する。

## 哲学：Nix-Firstアプローチ
- ✅ **CLIツール**: 100% Nixで管理（`home/packages.nix`）
- ✅ **システムパッケージ**: Nixで管理（`darwin-configuration.nix`）
- ⚠️ **GUIアプリ**: Homebrew Caskで管理（nixpkgsで利用できない場合のみ）

## 技術スタック
- **言語**: Nix
- **パッケージマネージャー**: Nix（Flakes使用）
- **システム設定**: nix-darwin
- **ユーザー設定**: home-manager
- **シェル**: Fish
- **エディタ**: Helix
- **ターミナル**: Ghostty
- **テーマ**: Tokyo Night（統一テーマ）

## 主要な依存関係
- `nixpkgs-24.11-darwin` (stable)
- `nixpkgs-unstable` (latest packages)
- `nix-darwin`
- `home-manager/release-24.11`

## プラットフォーム
- macOS (aarch64-darwin / Apple Silicon)
- Intel Macの場合は `x86_64-darwin` に変更が必要
