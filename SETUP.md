# Setup Notes (Arch / Hyprland)

このdotfilesのセットアップ内容と、2026-08時点で実施したカスタマイズの記録。

## 環境

- Arch Linux / Hyprland / SDDM / ghostty / zsh + p10k
- 日本語入力: fcitx5 + mozc
- シングルモニタ (3440x1440 ウルトラワイド)
- デスクトップPC (バッテリー・内蔵バックライトなし)

## キーバインド (Hyprland, `$mainMod` = Super)

| キー | 動作 |
|---|---|
| Super+Return | ターミナル (ghostty) |
| Super+E | ファイルマネージャ (yazi) |
| Super+M | rofiランチャー |
| Super+B | ブラウザ (brave) |
| Super+V / Super+Shift+V | nvim / **クリップボード履歴 (cliphist)** |
| Super+P | herdr (ターミナル内) |
| Super+R | waybar再起動スクリプト |
| Super+S | スクラッチパッド表示/非表示 (special:magic) |
| Super+Shift+S | アクティブウィンドウをスクラッチパッドへ移動 |
| **Print** | 全画面スクリーンショット (保存+クリップボード) |
| **Shift+Print** | 範囲選択スクリーンショット |
| Ctrl+Shift+Q | ロック (hyprlock) |
| **Super+Shift+Q** | **電源メニュー (wlogout)** |
| Super+Q | ウィンドウを閉じる |

## 今回のセッションで実施した設定

### 1. dotfiles整理 (初期)
- `.zshrc`, `.p10k.zsh` のみだったリポジトリに、シェル設定(`.zshenv`, `.gitconfig`, `.bashrc`, `.bash_profile`)と `~/.config/` 配下の主要設定を全て追加
- `install.sh`: 全ファイル/ディレクトリをホームにシンボリックリンク。既存設定は `backup/<日時>/` に退避
- `.gitignore`: 壁紙(`hyprlock.png`)と `backup/` を除外
- `.zshrc` の p10k instant prompt を先頭付近へ移動 (末尾だと動作しない)
- `ls` エイリアスは `exa` (`eza` が後継、置き換え候補)

### 2. Bluetoothキーボード
- bluez導入済み(既存)。`bluetoothctl` でペアリング
- GUI管理に **blueman** をインストール。**トレイアプレット(blueman-applet)は未起動**なので注意

### 3. ダークテーマ
- `gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'` (GTK4/libadwaita用)
- `~/.config/gtk-3.0/settings.ini` に `gtk-application-prefer-dark-theme=true` (GTK3用)
- `hyprland.conf` の `env = GTK_THEME,Adwaita:dark` も有効

### 4. 日本語入力のCapsLock切替
- `~/.config/fcitx5/config` の `[Hotkey/TriggerKeys]` に `CAPS_LOCK` を追加
- これでCapsLockで全角/半角を切替 (Capsキー本来の機能は犠牲)
- fcitx5の `config` と `profile` をリポジトリに追加 (`conf/cached_layouts` は自動生成のため除外)

### 5. スクリーンショット
- `grim` + `slurp` を導入
- Print=全画面 / Shift+Print=範囲選択 (両方 `~/Pictures/Screenshots/` に保存+クリップボードへ)
- **注意**: 最初 `Super+Shift+S` に割当てたが、既存の `movetoworkspace special:magic`(スクラッチパッドへ移動)と衝突したため変更。Hyprlandは**後方の定義が優先**

### 6. クリップボードマネージャ
- `cliphist` を導入。`exec-once = wl-paste --watch cliphist store` で履歴保存
- Super+Shift+V で rofiから履歴選択 → クリップボードへ

### 7. manページ
- `man-db` 導入 (初期状態で未導入だった)
- `man-pages-ja` は**AUR**にしかない (`yay -S man-pages-ja`)。日本語manは `LANG=ja_JP.UTF-8` で有効

### 8. 電源メニュー (wlogout)
- **AUR**にのみ存在 (`yay -S wlogout`)。ビルドに `pkgconf` が必要だった
- Super+Shift+Q で表示。ボタン: ロック/ログアウト/サスペンド(ロック+スリープ)/再起動/シャットダウン
- **`wlogout -b 5` 必須**: デフォルトは1行3列グリッドで、5ボタンだと6マス目が空白パネルになる
- デザイン: 透明ボタン+中央アイコン (GTKは `max-width` や `padding: %` 非対応)

## インストールしたパッケージ (このセッション)

```
pacman: grim slurp cliphist man-db pkgconf blueman
AUR:   man-pages-ja wlogout
```

## その他メモ

- **スクラッチパッド**: herdrがspecial:magicに置かれていることがある。Super+Sで表示/非表示トグル
- **herdr**: 当初 `launch_dev.sh` から変更。`$terminal -e herdr` でghostty内で起動。ターミナルなしで起動するとtty1に張り付く
- `hyprlock.png`(壁紙) はリポジトリに含めない。`~/.config/hypr/` に手動配置
- `~/.local/bin/launch_dev.sh` は旧プロジェクトへのsymlink。不要なら削除可
- 明るさキー(brightnessctl)はデスクトップのため実質使えない死コード
- 未対応項目: pacmanのColor有効化、reflectorミラー最適化、hypridleの実サスペンド

## 10. SSDのTRIM
- NVMe (INTEL SSDPEKNW512G8, 512GB) を確認
- `fstrim.timer` を有効化(enabled + active)。毎週自動でTRIM実行
- 手動実行は `sudo fstrim -av`

## 9. ファイアウォール (ufw)
- `ufw` を導入し有効化。デフォルト方針: **着信=拒否 / 発信=許可**
- `SSH (22/tcp)` のみ許可
- `systemctl enable --now ufw` 済み(再起動後も維持)
- 以前は待受ポートがゼロで「たまたま安全」だった。今後サービスを公開する際は `sudo ufw allow <port>` で個別許可
