# ~/.zshenv

# 1. 既存のPATHを維持しつつ、必要なパスを追加
typeset -U path  # 重複したパスを自動で取り除くZshの便利機能
path=(
    $HOME/.local/bin
    $HOME/.cargo/bin
    $HOME/.npm-global/bin
    $path
)
export PATH

# 2. その他の重要な環境変数
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="ja_JP.UTF-8"
