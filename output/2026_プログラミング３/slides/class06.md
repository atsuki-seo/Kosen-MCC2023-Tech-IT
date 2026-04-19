---
marp: true
theme: yuge
paginate: true
header: '弓削商船高等専門学校 情報工学科 プログラミング３ 2026年度講義資料'
footer: ''
math: mathjax
---

<!--
class: flex-layout natural-height
-->

# プログラミング３ 講義資料

## 第6回 GitHub とリモートリポジトリ

- GitHub とホスティングサービス
- リモート操作: clone / push / pull / fetch
- 認証と .gitignore

---

# 目次

- GitHub 概要
- リモートリポジトリ操作

---

# GitHub 概要

---

<!--
class: flex-layout
-->

# 今回の目的と到達目標

<div class="columns">
<div>

## 今回の目的
- GitHub の役割を理解
- リモート操作ができる
- 認証方法を知る

</div>
<div>

## 到達目標
- [2] git/GitHub の基本操作（リモート）

</div>
</div>

---

<!--
class: flex-layout natural-height
-->

# git と GitHub の違い

| 項目 | git | GitHub |
|------|-----|--------|
| 立ち位置 | バージョン管理ソフトウェア | ホスティングサービス |
| 動作 | 手元で完結 | Web 上で共有 |
| 提供元 | オープンソース | 企業サービス |
| 他の例 | — | GitLab / Bitbucket / Gitea 等 |

- git なしで GitHub は使えない、GitHub なしでも git は使える
- GitHub の強みは **共同作業のための Web UI と API**

---

<!--
class: flex-layout natural-height
-->

# リモート操作の全体像

ローカル `⇄` リモート（GitHub）

| コマンド | 方向 | 目的 |
|---------|------|------|
| `git clone <url>` | リモート → ローカル | リポジトリ一式を取得 |
| `git fetch` | リモート → ローカル | 履歴のみ取得（作業ツリーは変えない） |
| `git pull` | リモート → ローカル | fetch + merge |
| `git push` | ローカル → リモート | 自分のコミットを送る |

- `origin` はリモートの既定名（別名も付けられる）

---

<!--
class: flex-layout natural-height
-->

# 初回の push

既存ローカルリポジトリを GitHub に公開する流れ:

```bash
# GitHub で空のリポジトリを作成
git remote add origin https://github.com/<user>/<repo>.git
git branch -M main
git push -u origin main    # -u で追跡ブランチを設定
```

2回目以降は単に `git push` でよい。

---

<!--
class: flex-layout natural-height
-->

# 認証: HTTPS と SSH

| 方式 | URL 形式 | 認証 |
|------|---------|------|
| HTTPS | `https://github.com/...` | Personal Access Token |
| SSH | `git@github.com:...` | 公開鍵認証 |

- パスワード認証は廃止済み
- 授業では SSH 鍵の設定を推奨（一度設定すれば以後は入力不要）

---

<!--
class: flex-layout
-->

# .gitignore とリポジトリ衛生

<div class="summary-positive">

## Tips

- **コミットしないもの**: ビルド成果物・秘密鍵・個人情報・巨大な生成物
- `.gitignore` にパターンを書いて除外する
- 一度コミットしたファイルを後から `.gitignore` しても履歴からは消えない
- `git status` で **想定外の差分が出ていないか** 毎回確認する

</div>

---

# 今回のまとめ

- git はツール、GitHub はホスティング — 役割が違う
- リモート操作: `clone` / `fetch` / `pull` / `push`、既定リモート名は `origin`
- SSH 鍵で認証、`.gitignore` で機密・不要ファイルを除外

### 今回カバーした MCC 項目

- V-D-1 プログラミング

### 次回予告

- 第7回: GitHub Issue・Pull Request とコードレビュー
