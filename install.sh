#!/bin/bash
# dotfiles の設定をホームディレクトリにシンボリックリンクで配置する
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$DOTFILES/backup/$(date +%Y%m%d_%H%M%S)"

# ホーム直下に配置するファイル
home_files=(.zshrc .p10k.zsh .zshenv .gitconfig .bashrc .bash_profile)

# ~/.config 配下に配置するディレクトリ
config_dirs=(hypr waybar swaync rofi nvim ghostty yazi zellij fontconfig waypaper fnott)

link() {
  local target="$1"
  local link_path="$2"
  if [ -L "$link_path" ]; then
    rm "$link_path"
  elif [ -e "$link_path" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$link_path" "$BACKUP_DIR/"
    echo "backed up: $link_path -> $BACKUP_DIR/"
  fi
  ln -s "$target" "$link_path"
  echo "linked: $link_path -> $target"
}

for file in "${home_files[@]}"; do
  link "$DOTFILES/$file" "$HOME/$file"
done

mkdir -p "$HOME/.config"
for dir in "${config_dirs[@]}"; do
  link "$DOTFILES/.config/$dir" "$HOME/.config/$dir"
done
