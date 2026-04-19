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

## 出典

- [高専機構 モデルコアカリキュラム（令和5年度版）](https://kosen-k.go.jp/wp/wp-content/uploads/2023/12/2c383e29-7e20-4b20-af19-ca3737450665.pdf)
