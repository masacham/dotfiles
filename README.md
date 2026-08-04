# dotfiles
masacham's dotfiles for Arch Linux (Hyprland) environment

## 含まれる設定
- シェル: `.zshrc`, `.p10k.zsh`, `.zshenv`, `.bashrc`, `.bash_profile`
- git: `.gitconfig`
- Hyprland: `.config/hypr/`
- デスクトップ: `.config/waybar/`, `.config/swaync/`, `.config/rofi/`, `.config/fnott/`, `.config/waypaper/`
- ターミナル: `.config/ghostty/`
- エディタ: `.config/nvim/` (LazyVim)
- ファイル管理: `.config/yazi/`, `.config/zellij/`
- フォント: `.config/fontconfig/`
- GTKテーマ: `.config/gtk-3.0/settings.ini` (ダークテーマ)

## インストール
```sh
./install.sh
```
既存の設定ファイルがある場合は `backup/<日時>/` に退避してからシンボリックリンクを作成します。

## 注意
- 壁紙画像 (`hyprlock.png` 等) はリポジトリに含まれていません。`.config/hypr/` に手動で配置してください。
