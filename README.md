# NITYC-MCC-Tools

弓削商船高等専門学校（NITYC）の教育業務を支援するClaude Codeスキル集。高専モデルコアカリキュラム（MCC）に基づく情報系分野（V-D）の参照資料とスキルを提供する。

## 概要

- MCCに基づいたシラバス作成を支援
- 情報系分野（プログラミング、ソフトウェア、計算機工学、ネットワーク等）に対応
- テスト問題の自動生成とMoodle XMLでの出力を支援
- レポート・成果物課題の生成と自動採点を支援
- シラバスから授業用Marpスライドを生成

## 含まれるファイル

| ファイル/フォルダ | 説明 |
|------------------|------|
| `docs/Kosen-MCC2023-Tech.pdf` | MCC2023原本 |
| `.claude/skills/class-syllabus/` | シラバス作成スキル |
| `.claude/skills/class-test/` | テスト問題生成スキル |
| `.claude/skills/class-report/` | レポート課題生成スキル |
| `.claude/skills/class-report-check/` | レポート採点スキル |
| `.claude/skills/class-slides/` | 授業用Marpスライド生成スキル |
| `CLAUDE.md` | Claude Code用の指示ファイル |

## スキルの実行順序・ユースケース

### 依存関係

```
class-syllabus
   └─→ class-syllabus-parse （共通前処理: 後続スキルから自動案内される）
          ├─→ class-test
          ├─→ class-report
          │     └─→ class-report-check （学生提出物の採点時）
          └─→ class-slides
```

`class-syllabus-parse` は単独で使うスキルではなく、後続スキル（test/report/slides）が未解析時にユーザーに事前実行を案内する**共通前処理**。複数の後続スキルを連続利用する場合のみ、先に1回実行しておくとコンテキスト再利用で効率化できる（Tips）。

### ユースケース別フロー

**1. 新規科目を立ち上げる**
`/class-syllabus` でシラバスを作成 → 必要に応じて後続スキルへ

**2. 既存シラバスからテストを作る**
`/class-test` を実行（未解析なら `/class-syllabus-parse` の事前実行が自動案内される）

**3. 既存シラバスからレポート課題を作る**
`/class-report` で課題・ルーブリック生成 → 学生提出後に `/class-report-check` で採点

**4. 既存シラバスからスライドを作る**
`/class-slides` を実行。提出物該当回の詳細化が必要なら `/class-test` `/class-report` を先に実行しておく

**5. 複数スキルを連続利用する（効率化Tips）**
先に `/class-syllabus-parse` を1回実行してコンテキストに乗せ、以降 test/report/slides で再利用する

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

## class-reportスキル

シラバスMarkdownからレポート・成果物課題の出題文と採点用ルーブリックを生成するスキル。

使い方: Claude Codeで `/class-report` を実行

主な機能:
- シラバスの授業計画・到達目標・ルーブリックから課題内容を具体化
- シラバスにレポート詳細がない場合はテーマ候補を3案自動生成
- 個人レポート・チームレポート（共通点数）の両方に対応
- 課題文Markdown + 採点用ルーブリックMarkdownを出力

## class-report-checkスキル

学生のレポート提出物をルーブリックに基づいて自動採点するスキル。

使い方: Claude Codeで `/class-report-check` を実行

主な機能:
- ディレクトリ内の提出物を一括処理（Markdown・コード・PDF対応）
- アンカー採点方式で採点の一貫性を確保（3件サンプリング→基準確立→一括採点）
- 観点別評価・フィードバックコメント・成績一覧CSVを出力
- 個人・チーム提出の両方に対応

## class-slidesスキル

シラバスMarkdownから授業用Marpスライドを生成するスキル。1回=1ファイル単位、シーズン全回一括生成に対応。

使い方: Claude Codeで `/class-slides` を実行

主な機能:
- シラバスの授業計画・到達目標・ルーブリック・試験/レポートスケジュール・MCC対応を入力に、各回のスライドを自動生成
- Marpテーマ `yuge` 固定（別途インストール必要）
- 骨子（全回一覧）→ 回ごとの詳細化、の2段階で生成（前後参照と用語統一を担保）
- 提出物該当回は `reports/` `tests/` の成果物から課題文・期限・ルーブリック要約を展開
- 授業時間に応じた枚数目安（30分=10枚 / 60分=20枚 / 90分=30枚）
- mermaidによる概念図の自動生成（写真・イラストは対象外）

## 出典

- [高専機構 モデルコアカリキュラム（令和5年度版）](https://kosen-k.go.jp/wp/wp-content/uploads/2023/12/2c383e29-7e20-4b20-af19-ca3737450665.pdf)
