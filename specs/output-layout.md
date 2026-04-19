# 出力ディレクトリ・ファイル命名規約

`output/` 配下のディレクトリ構造とファイル命名の**共有契約**。複数スキル（`class-syllabus` / `class-test` / `class-report` / `class-report-check` / `class-slides`）が読み書きするファイルパスの正本である。

このファイルは「誰が書いて誰が読むか」の契約を一元管理する。各スキルのリファレンスに同じパス規約を二重記述せず、必ず本ファイルを参照すること。

## 参照元スキル

- `class-syllabus`: シラバス本体（Excel + Markdown）の出力先
- `class-syllabus-parse`: ファイル出力なし。`output/` 配下の glob 探索のみ
- `class-test`: テスト関連ファイルの出力先
- `class-report`: レポート課題関連ファイルの出力先
- `class-report-check`: 採点結果の出力先（class-report の出力を入力として読む）
- `class-slides`: スライドファイルの出力先（class-test/class-report の出力を任意参照する）
- `class-load`: `output/` 配下の glob 探索のみ

---

## 1. ルートレイアウト

すべての成果物は科目専用フォルダ `output/[YYYY]_[教科名]/` 配下に配置する。

```
output/
└── [YYYY]_[教科名]/                       ← 科目フォルダ（例: 2026_アルゴリズム）
    ├── [シラバスファイル名].md            ← class-syllabus 出力
    ├── [シラバスファイル名].xlsx          ← class-syllabus 出力（Excel併用時）
    ├── tests/
    │   └── [テスト名]/                    ← class-test 出力
    │       ├── [テスト名]_確認用.md
    │       ├── [テスト名]_解説.md
    │       ├── [テスト名]_moodle.xml
    │       └── [テスト名]_事前通知.md     ← オプション
    ├── reports/
    │   └── [レポート名]/                  ← class-report / class-report-check 共用
    │       ├── [レポート名]_課題.md       ← class-report 出力
    │       ├── [レポート名]_ルーブリック.md ← class-report 出力
    │       ├── [レポート名]_採点一覧.md   ← class-report-check 出力
    │       ├── [レポート名]_成績.csv      ← class-report-check 出力
    │       ├── submissions/               ← class-report が空作成、教員が提出物を配置
    │       └── feedback/
    │           └── [学籍番号]_[氏名]_feedback.md  ← class-report-check 出力
    └── slides/
        └── classNN.md                     ← class-slides 出力（NN は2桁ゼロ埋め）
```

### 1.1 科目フォルダ名

- 形式: `[YYYY]_[教科名]`
- `[YYYY]`: 開講年度（4桁西暦）
- `[教科名]`: シラバスの「教科名」項目をそのまま使用
- 例: `2026_アルゴリズム`, `2025_コンパイラ`

### 1.2 シラバスファイル名

- Excel併用時: 元のExcelファイル名（拡張子なし）+ `.md`
  - 例: `26開講情報工学科3アルゴリズム.xlsx` → `26開講情報工学科3アルゴリズム.md`
- Excel無し時: `[教科名].md`
  - 例: `アルゴリズム.md`

### 1.3 テスト名・レポート名の正規化

`[テスト名]` / `[レポート名]` は `syllabus-markdown-schema.md` § 5（名前の正規化ルール）に従い正規化済みであること。

---

## 2. ファイル一覧表（誰が書いて誰が読むか）

### 2.1 class-syllabus

| ファイル | 役割 | 生成者 | 参照者 |
|---------|------|--------|--------|
| `[シラバスファイル名].md` | シラバス本体 | class-syllabus | class-syllabus-parse, class-load |
| `[シラバスファイル名].xlsx` | エクセルシラバス | class-syllabus | （教員が直接利用） |

### 2.2 class-test

| ファイル | 役割 | 生成者 | 参照者 |
|---------|------|--------|--------|
| `tests/[テスト名]/[テスト名]_確認用.md` | 教員確認用Markdown | class-test | class-slides（任意参照） |
| `tests/[テスト名]/[テスト名]_解説.md` | 詳細解説 | class-test | （教員が直接利用） |
| `tests/[テスト名]/[テスト名]_moodle.xml` | Moodle問題バンクXML | class-test | （Moodleにインポート） |
| `tests/[テスト名]/[テスト名]_事前通知.md` | 学生向け事前通知 | class-test（オプション） | （教員が学生に展開） |

### 2.3 class-report

| ファイル | 役割 | 生成者 | 参照者 |
|---------|------|--------|--------|
| `reports/[レポート名]/[レポート名]_課題.md` | 学生向け出題文 | class-report | class-report-check, class-slides（任意参照） |
| `reports/[レポート名]/[レポート名]_ルーブリック.md` | 採点ルーブリック | class-report | class-report-check, class-slides（任意参照） |
| `reports/[レポート名]/submissions/` | 提出物配置先（空ディレクトリ） | class-report | class-report-check |

### 2.4 class-report-check

| ファイル | 役割 | 生成者 | 参照者 |
|---------|------|--------|--------|
| `reports/[レポート名]/feedback/[学籍番号]_[氏名]_feedback.md` | 個別フィードバック | class-report-check | （教員が学生に展開） |
| `reports/[レポート名]/[レポート名]_採点一覧.md` | 採点一覧Markdown | class-report-check | （教員が確認） |
| `reports/[レポート名]/[レポート名]_成績.csv` | 成績CSV（UTF-8 BOM） | class-report-check | （成績処理に利用） |

### 2.5 class-slides

| ファイル | 役割 | 生成者 | 参照者 |
|---------|------|--------|--------|
| `slides/classNN.md` | Marpスライド（1回=1ファイル） | class-slides | （Marpでビルド） |

`NN` は2桁ゼロ埋めの回番号（例: `class01.md`, `class15.md`）。ソート順を保証するためゼロ埋め必須。

---

## 3. ファイル名サフィックス規約

各スキルが生成するファイル名のサフィックス（テスト名・レポート名の後に付く部分）を一覧化する。

| サフィックス | 用途 | 生成スキル |
|-------------|------|-----------|
| `_確認用.md` | 教員確認用 | class-test |
| `_解説.md` | 詳細解説 | class-test |
| `_moodle.xml` | Moodle XML | class-test |
| `_事前通知.md` | 学生向け事前通知 | class-test |
| `_課題.md` | 学生向け出題文 | class-report |
| `_ルーブリック.md` | 採点ルーブリック | class-report |
| `_採点一覧.md` | 採点一覧 | class-report-check |
| `_成績.csv` | 成績CSV | class-report-check |
| `_feedback.md` | 個別フィードバック（学籍番号_氏名 の後） | class-report-check |

---

## 4. 別名保存時の命名規則

既存ファイル/ディレクトリ検出時の上書き判定・別名保存ルールは `specs/file-output-policy.md` を参照（第2弾で追加予定）。

暫定ルール（class-test 現行仕様）:
- `tests/小テスト1/` が存在する場合、`tests/小テスト1_v2/` に保存
- `_v2` も存在する場合は `_v3`, `_v4` と自動インクリメント
- 別名保存時はディレクトリ名・ファイル名・XMLカテゴリ名すべてを同期する

---

## 5. ディレクトリ作成の責任

- **科目フォルダ `output/[YYYY]_[教科名]/`**: 最初に書き込むスキル（通常 class-syllabus）が `mkdir -p` で作成
- **`tests/[テスト名]/`**: class-test が作成
- **`reports/[レポート名]/`**: class-report が作成
- **`reports/[レポート名]/submissions/`**: class-report が空作成
- **`reports/[レポート名]/feedback/`**: class-report-check が作成
- **`slides/`**: class-slides が作成

各スキルは出力前に `mkdir -p` で必要な親ディレクトリを作成する。
