# Claude Code custom skills
{ config, pkgs, lib, ... }:

{
  home.file.".claude/skills/commit/skill.md".text = ''
    # commit

    変更内容を分析し、Conventional Commits形式でコミットを作成するスキル。

    ## 動作

    1. `git status` で変更ファイルを確認
    2. `git diff` で変更内容を分析
    3. `git log` で最近のコミットスタイルを確認
    4. 変更内容に基づいてコミットメッセージを生成
    5. ユーザーの承認後、コミットを実行

    ## コミットメッセージ形式

    Conventional Commits に従う：

    ```
    <type>: <description>

    [optional body]

    Co-Authored-By: Claude <noreply@anthropic.com>
    ```

    ### Type

    - `feat`: 新機能
    - `fix`: バグ修正
    - `docs`: ドキュメント
    - `style`: フォーマット（コードの動作に影響しない）
    - `refactor`: リファクタリング
    - `test`: テスト
    - `chore`: その他（ビルド、CI等）

    ## コミット前のチェック

    コミット前に以下を確認する：

    1. **コード品質**: プロジェクトで定義されているリンター・フォーマッターを実行
    2. **テスト**: 関連するテストが通ることを確認
    3. **ビルド**: ビルドが通ることを確認（必要な場合）

    ※ 具体的なコマンドはプロジェクトの設定ファイルを確認して実行する

    ## 注意事項

    - 秘密情報や認証情報を含むファイルはコミットしない
    - 意味のある単位でコミットする
    - 大きな変更は複数のコミットに分割することを検討
  '';

  home.file.".claude/skills/ask-gemini/skill.md".text = ''
    ---
    name: ask-gemini
    description: Gemini CLIに相談・レビューを依頼する
    ---

    # ask-gemini

    Gemini CLIを使って、コードレビューや技術的な相談を行います。

    ## 使い方

    - `/ask-gemini <質問や相談内容>`
      Geminiに質問や相談を投げかけ、回答を得る

    - `/ask-gemini review`
      現在の作業内容についてGeminiにレビューを依頼する

    ## 実行方法

    以下のコマンドでGemini CLIを呼び出します：

    ```bash
    # 非インタラクティブ実行（ワンショット）
    gemini "$PROMPT"

    # インタラクティブモードで続行する場合
    gemini -i "$PROMPT"
    ```

    ## 相談のガイドライン

    1. **質問を明確に**: 具体的な質問や課題を伝える
    2. **コンテキストを共有**: 必要に応じてファイルの内容や差分を含める
    3. **批判的に受け取る**: Geminiの回答を鵜呑みにせず、自分で判断する

    ## 注意事項

    - Gemini CLIが必要です（`home/packages.nix`に追加、または`nix run nixpkgs#gemini-cli`で実行可能）
    - API利用料が発生する場合があります
    - 回答はあくまで参考として、最終判断は自分で行ってください
  '';

  home.file.".claude/skills/ask-codex/skill.md".text = ''
    ---
    name: ask-codex
    description: OpenAI Codex CLIにコードレビューを依頼する
    ---

    # ask-codex

    OpenAI Codex CLIを使って、コードレビューや技術的な相談を行います。

    ## 使い方

    - `/ask-codex <質問や相談内容>`
      Codexに質問や相談を投げかけ、回答を得る

    - `/ask-codex review`
      現在の作業内容についてCodexにレビューを依頼する

    ## 実行方法

    以下のコマンドでCodex CLIを呼び出します：

    ```bash
    codex "$PROMPT"
    ```

    ## 相談のガイドライン

    1. **質問を明確に**: 具体的な質問や課題を伝える
    2. **コンテキストを共有**: 必要に応じてファイルの内容や差分を含める
    3. **批判的に受け取る**: Codexの回答を鵜呑みにせず、自分で判断する

    ## 注意事項

    - Codex CLIが必要です（`home/packages.nix`に追加、または`nix run nixpkgs#openai-codex`で実行可能）
    - OpenAI APIキーが設定されている必要があります
  '';

  home.file.".claude/skills/ask-peer/skill.md".text = ''
    ---
    name: ask-peer
    description: 同僚エンジニアとしてサブエージェントに相談する
    ---

    # ask-peer

    Claude Codeのサブエージェント機能を使って、「同僚エンジニア」として技術的な相談やレビューを行います。

    ## 使い方

    - `/ask-peer <質問や相談内容>`
      同僚エンジニアとして、技術的な相談やレビューを依頼する

    - `/ask-peer review`
      現在の作業内容について同僚視点でレビューを依頼する

    ## 実行方法

    Task toolを使用して、general-purposeサブエージェントを「同僚エンジニア」として呼び出します。

    サブエージェントには以下のペルソナを与えます：

    ```
    あなたは経験豊富な同僚エンジニアです。
    以下の観点でレビュー・相談に応じてください：

    1. **設計の妥当性**: アーキテクチャや設計パターンの適切さ
    2. **コード品質**: 可読性、保守性、テスタビリティ
    3. **潜在的な問題**: バグ、パフォーマンス、セキュリティリスク
    4. **改善提案**: より良いアプローチがあれば提案

    率直かつ建設的なフィードバックをお願いします。
    ```

    ## 相談のガイドライン

    1. **具体的に質問**: 何について相談したいか明確に
    2. **コンテキスト共有**: 関連するコードや背景を伝える
    3. **複数の視点を比較**: 他のAI（Gemini、Codex）の意見と比較検討する

    ## 注意事項

    - サブエージェントの回答を鵜呑みにせず、批判的に検討してください
    - 最終的な判断と責任は自分で持つこと
    - トークン消費が増えるため、必要な時に使用してください
  '';

  home.file.".claude/skills/explaining-code/skill.md".text = ''
    ---
    name: explaining-code
    description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
    ---

    # explaining-code

    コードを視覚的な図と例え話を使って説明するスキル。

    ## 使い方

    - `/explaining-code <ファイルパスまたはコード>` - コードの動作を説明
    - コードの理解を深めたい時に使用

    ## 説明の原則

    1. **図解優先**: Mermaidダイアグラムやアスキーアートで視覚化
    2. **例え話**: 日常的な概念に例えて説明
    3. **段階的**: 簡単な部分から複雑な部分へ
    4. **実行フロー**: データの流れを追跡

    ## 出力フォーマット

    ```markdown
    ## 概要
    このコードは〜をするものです。

    ## 図解
    [Mermaidダイアグラムまたはアスキーアート]

    ## 例え話
    これは〜のようなものです。

    ## 詳細
    1. 最初に〜
    2. 次に〜
    3. 最後に〜
    ```
  '';

  home.file.".claude/skills/ui-skills/skill.md".text = ''
    ---
    name: ui-skills
    description: Opinionated constraints for building better interfaces with agents.
    ---

    # ui-skills

    AIエージェントでより良いUIを構築するための制約とガイドライン。

    ## 原則

    1. **シンプルさ優先**: 複雑なUIより単純なUIを選ぶ
    2. **アクセシビリティ**: a11yを常に考慮
    3. **パフォーマンス**: 軽量なコンポーネント
    4. **一貫性**: デザインシステムに従う

    ## コンポーネント設計

    - 単一責任の原則を守る
    - Props は最小限に
    - 状態は上位で管理
    - スタイルは Tailwind で統一

    ## 禁止事項

    - インラインスタイル（例外を除く）
    - 過度なネスト
    - マジックナンバー
    - 未定義の色・サイズ
  '';

  home.file.".claude/skills/vercel-react-best-practices/skill.md".text = ''
    ---
    name: vercel-react-best-practices
    description: React and Next.js performance optimization guidelines from Vercel Engineering. This skill should be used when writing, reviewing, or refactoring React/Next.js code to ensure optimal performance patterns. Triggers on tasks involving React components, Next.js pages, data fetching, bundle optimization, or performance improvements.
    ---

    # Vercel React Best Practices

    VercelエンジニアリングによるReact/Next.jsパフォーマンス最適化ガイドライン。

    ## Server Components

    - デフォルトでServer Componentsを使用
    - 'use client'は必要な場合のみ
    - データフェッチはサーバーで行う

    ## データフェッチング

    - `fetch` with caching
    - `unstable_cache` for database queries
    - Streaming with Suspense

    ## バンドル最適化

    - Dynamic imports for heavy components
    - Tree shaking friendly exports
    - Image optimization with next/image

    ## レンダリング

    - Avoid unnecessary re-renders
    - Use `memo` sparingly and correctly
    - Prefer composition over prop drilling
  '';

  home.file.".claude/skills/web-design-guidelines/skill.md".text = ''
    ---
    name: web-design-guidelines
    description: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
    argument-hint: <file-or-pattern>
    ---

    # Web Interface Guidelines

    Review files for compliance with Web Interface Guidelines.

    ## How It Works

    1. Fetch the latest guidelines from the source URL below
    2. Read the specified files (or prompt user for files/pattern)
    3. Check against all rules in the fetched guidelines
    4. Output findings in the terse `file:line` format

    ## Source

    Guidelines are fetched from: https://interfaces.rauno.me/

    ## Output Format

    ```
    ✅ Passes: [count]
    ⚠️ Warnings: [count]
    ❌ Violations: [count]

    ## Violations
    - file.tsx:42 - [Rule Name]: Description

    ## Warnings
    - file.tsx:15 - [Rule Name]: Description
    ```
  '';
}
