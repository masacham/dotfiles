# dotfiles — Agent Guide

このリポジトリは Arch Linux (Hyprland) 環境の設定ファイル管理用です。
`~/` と `~/.config/` の設定をシンボリックリンクで管理しています。

## セットアップ内容

- この環境で実施した設定・キーバインド・注意点の詳細は **`SETUP.md`** を参照。
- 設定変更を依頼されたら、まず `SETUP.md` を読んで現在の構成を把握すること。

## 構成ルール

- ホーム直下の設定 (`~/.zshrc` 等) と `~/.config/` 配下の設定を、このリポジトリに**ミラー**して保存する。
- 設定を追加/変更したら、以下も必ず更新すること:
  - `install.sh` の `home_files` / `config_dirs` 配列に対象を追加
  - `README.md` の「含まれる設定」一覧
  - `SETUP.md` に設定内容と注意点を追記
- `~/.config/` の変更をリポジトリへ同期する際は `cp` でコピー(ミラー)し、`diff` で確認する。

## 除外ポリシー

- 壁紙や大きなバイナリ (`hyprlock.png`) は `.gitignore` で除外。
- 自動生成ファイル (例: `~/.config/fcitx5/conf/cached_layouts`) は含めない。
- 実行時のログ・ソケット (`herdr/*.log`, `*.sock`) は含めない。

## 変更の手順

1. 設定ファイルを変更(ホーム側とリポジトリ側の両方に反映)
2. 動作確認(`hyprctl reload` 等、必要に応じてテスト)
3. `install.sh` / `README.md` / `SETUP.md` を更新
4. `git add` → コミット → プッシュ(明示的に指示された場合)
