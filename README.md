# NITYC-MCC-Tools

弓削商船高等専門学校（NITYC）の教育業務を支援するClaude Codeスキル集。高専モデルコアカリキュラム（MCC）に基づく情報系分野（V-D）の参照資料とスキルを提供する。

## 概要

- MCCに基づいたシラバス作成を支援
- 情報系分野（プログラミング、ソフトウェア、計算機工学、ネットワーク等）に対応
- テスト問題の自動生成とMoodle XMLでの出力を支援
- 今後、スライド作成等のスキルも追加予定

## 含まれるファイル

| ファイル/フォルダ | 説明 |
|------------------|------|
| `docs/Kosen-MCC2023-Tech.pdf` | MCC2023原本 |
| `.claude/skills/class-syllabus/` | シラバス作成スキル |
| `.claude/skills/class-test/` | テスト問題生成スキル |
| `CLAUDE.md` | Claude Code用の指示ファイル |

## class-syllabusスキル

MCCに沿ったシラバスをエクセルテンプレートから作成・出力するスキル。

使い方: Claude Codeで `/class-syllabus` を実行

2つのフローに対応:
- **従来フロー**: 到達目標をもとに授業計画を組み立てる
- **逆算フロー**: MCCカテゴリを起点に、トピック洗い出し→到達目標生成→週次計画の逆算を行う

## class-testスキル

シラバスMarkdownから小テスト・定期試験の問題と模範解答を生成するスキル。

使い方: Claude Codeで `/class-test` を実行

主な機能:
- シラバスの授業計画・到達目標・試験範囲から問題構成を自動設計
- Moodle 4.x 自動採点対応の6形式（多肢選択、数値、穴埋めCloze、マッチング、記述、計算）に対応
- AI利用前提の出題戦略（Calculated問題によるランダム化等）
- Moodle XML・確認用Markdown・解説の3ファイルを出力

## 出典

- [高専機構 モデルコアカリキュラム（令和5年度版）](https://kosen-k.go.jp/wp/wp-content/uploads/2023/12/2c383e29-7e20-4b20-af19-ca3737450665.pdf)
