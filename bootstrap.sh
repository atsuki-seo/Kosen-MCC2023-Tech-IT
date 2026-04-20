#!/usr/bin/env bash
set -euo pipefail

# NITYC-MCC-Tools セットアップスクリプト
# - 依存コマンドの存在チェック（無ければ案内）
# - Python パッケージの導入（pip install --user）
# - marp-theme-nityc の clone
# - gh 認証状態の確認

MINIMAL=0
for arg in "$@"; do
  case "$arg" in
    --minimal) MINIMAL=1 ;;
    --help|-h)
      cat <<'EOF'
使い方: ./bootstrap.sh [オプション]

オプション:
  --minimal   slides/topic-explainers 関連（Node.js, Chrome, テーマ clone）をスキップ
  --help, -h  この使い方を表示

スクリプトの動作:
  1. 依存コマンドの存在チェック（無ければ案内のみ、自動インストールはしない）
  2. .claude/skills/*/requirements.txt を pip3 install --user
  3. ../marp-theme-nityc/ を SSH で clone（無い場合・--minimal ではスキップ）
  4. gh auth status を確認（未認証なら案内）
  5. 末尾にサマリを表示
EOF
      exit 0
      ;;
    *)
      echo "不明なオプション: $arg" >&2
      echo "使い方は ./bootstrap.sh --help を参照" >&2
      exit 2
      ;;
  esac
done

# 色付け（TTY のときのみ）
if [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  C_RESET="$(tput sgr0)"
  C_BOLD="$(tput bold)"
  C_GREEN="$(tput setaf 2)"
  C_YELLOW="$(tput setaf 3)"
  C_RED="$(tput setaf 1)"
  C_CYAN="$(tput setaf 6)"
else
  C_RESET=""; C_BOLD=""; C_GREEN=""; C_YELLOW=""; C_RED=""; C_CYAN=""
fi

# OS 判定
case "$(uname -s)" in
  Linux*)  OS=linux ;;
  Darwin*) OS=mac ;;
  *) echo "${C_RED}サポート外の OS です（Linux/macOS のみ対応）${C_RESET}" >&2; exit 1 ;;
esac

# サマリ用配列
declare -a OK_LIST=()
declare -a MISSING_LIST=()
declare -a TODO_LIST=()

section() {
  echo ""
  echo "${C_BOLD}${C_CYAN}== $1 ==${C_RESET}"
}
ok()    { echo "${C_GREEN}[OK]${C_RESET}      $1"; OK_LIST+=("$1"); }
miss()  { echo "${C_YELLOW}[MISSING]${C_RESET} $1"; MISSING_LIST+=("$1"); }
warn()  { echo "${C_YELLOW}[WARN]${C_RESET}    $1"; }
err()   { echo "${C_RED}[ERROR]${C_RESET}   $1" >&2; }
todo()  { TODO_LIST+=("$1"); }

# 依存コマンドチェック
check_cmd() {
  local cmd="$1" desc="$2" install_linux="$3" install_mac="$4"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$cmd ($desc)"
  else
    miss "$cmd ($desc)"
    if [ "$OS" = "linux" ]; then
      todo "$cmd: $install_linux"
    else
      todo "$cmd: $install_mac"
    fi
  fi
}

# Chrome は実行ファイル名が複数あり得るので個別に
check_chrome() {
  if command -v google-chrome >/dev/null 2>&1 \
     || command -v google-chrome-stable >/dev/null 2>&1 \
     || [ -d "/Applications/Google Chrome.app" ]; then
    ok "google-chrome (Marp の PDF レンダリング)"
  else
    miss "google-chrome (Marp の PDF レンダリング)"
    if [ "$OS" = "linux" ]; then
      todo "google-chrome: https://www.google.com/chrome/ から .deb をダウンロードしてインストール"
    else
      todo "google-chrome: brew install --cask google-chrome"
    fi
  fi
}

section "依存コマンドの確認"
check_cmd python3 "シラバス Excel 操作のランタイム" \
  "sudo apt install python3 python3-pip" \
  "brew install python3"
check_cmd gh "Issue 作成・認証" \
  "公式手順 https://github.com/cli/cli/blob/trunk/docs/install_linux.md" \
  "brew install gh"

if [ "$MINIMAL" -eq 0 ]; then
  check_cmd node "Marp スライドの PDF 変換ランタイム" \
    "sudo apt install nodejs npm" \
    "brew install node"
  check_chrome
fi

# Python パッケージ
section "Python パッケージの導入"
if command -v python3 >/dev/null 2>&1; then
  REQ_FILES=( $(find .claude/skills -name requirements.txt -type f 2>/dev/null || true) )
  if [ "${#REQ_FILES[@]}" -eq 0 ]; then
    warn "requirements.txt が見つかりません"
  else
    for req in "${REQ_FILES[@]}"; do
      echo "  → $req"
      if python3 -m pip install --user -r "$req" >/dev/null 2>&1; then
        ok "$req をインストール"
      else
        # PEP 668 等で失敗した場合はメッセージを出して継続
        if python3 -m pip install --user --break-system-packages -r "$req" >/dev/null 2>&1; then
          ok "$req をインストール（--break-system-packages）"
        else
          err "$req のインストールに失敗"
          todo "Python パッケージ: 手動で 'python3 -m pip install --user -r $req' を実行（PEP 668 環境では venv を検討）"
        fi
      fi
    done
  fi
else
  warn "python3 が無いため Python パッケージの導入をスキップ"
fi

# marp-theme-nityc の clone
if [ "$MINIMAL" -eq 0 ]; then
  section "marp-theme-nityc の取得"
  THEME_DIR="../marp-theme-nityc"
  if [ -d "$THEME_DIR" ]; then
    ok "$THEME_DIR は既に存在"
  else
    if command -v git >/dev/null 2>&1; then
      echo "  → git clone git@github.com:atsuki-seo/marp-theme-nityc.git $THEME_DIR"
      if git clone git@github.com:atsuki-seo/marp-theme-nityc.git "$THEME_DIR"; then
        ok "marp-theme-nityc を clone"
      else
        err "clone に失敗（SSH 鍵・ネットワーク・リポジトリアクセス権を確認）"
        todo "marp-theme-nityc: 手動で 'git clone git@github.com:atsuki-seo/marp-theme-nityc.git $THEME_DIR' を実行"
      fi
    else
      miss "git"
      todo "git をインストールしてから marp-theme-nityc を clone してください"
    fi
  fi
fi

# gh 認証
section "gh 認証の確認"
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    ok "gh 認証済み"
  else
    miss "gh 未認証"
    todo "gh: 'gh auth login' で認証してください"
  fi
else
  warn "gh が無いため認証チェックをスキップ"
fi

# サマリ
section "サマリ"
echo "${C_GREEN}OK: ${#OK_LIST[@]} 件${C_RESET}"
if [ "${#MISSING_LIST[@]}" -gt 0 ]; then
  echo "${C_YELLOW}MISSING: ${#MISSING_LIST[@]} 件${C_RESET}"
  for m in "${MISSING_LIST[@]}"; do echo "  - $m"; done
fi
if [ "${#TODO_LIST[@]}" -gt 0 ]; then
  echo ""
  echo "${C_BOLD}手動で対応してください:${C_RESET}"
  for t in "${TODO_LIST[@]}"; do echo "  - $t"; done
  exit 1
fi

echo ""
echo "${C_GREEN}${C_BOLD}✓ セットアップ完了${C_RESET}"
