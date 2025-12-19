# dotfiles

Windows (WSL)、macOS、Linux 間での環境差に依存しない開発環境設定管理

## 概要

このリポジトリは複数のプラットフォーム間で一貫した開発環境を構築するための dotfiles とスクリプトを提供します。

対応プラットフォーム:
- **Windows (WSL 2)** - Windows Subsystem for Linux
- **macOS** - Darwin
- **Linux** - Ubuntu、Debian など

## 特徴

- 🔄 プラットフォーム自動判別対応
- 📦 再現可能な環境構築
- 🛠️ 自動インストール・ブートストラップ
- 🔗 dotfiles のシンボリックリンク管理
- 🎯 コンポーネント単位での選択的インストール

## 前提条件

### 共通要件
- Git
- Bash または Zsh シェル

### プラットフォーム別要件

**Windows (WSL 2)**
- WSL 2 がインストール・設定済み
- 推奨: Ubuntu 20.04 LTS 以降

**macOS**
- macOS 10.15 (Catalina) 以降
- Xcode Command Line Tools: `xcode-select --install`

**Linux**
- Ubuntu 20.04 LTS または Debian 11 以降
- パッケージインストール用の `sudo` アクセス

## インストール

### クイックスタート

**Linux/WSL:**
```bash
git clone https://github.com/masacham/dotfiles ~/.dotfiles
cd ~/.dotfiles
./scripts/symlink.sh
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/masacham/dotfiles $env:USERPROFILE\.dotfiles
cd $env:USERPROFILE\.dotfiles
# 管理者権限で実行
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\scripts\symlink.ps1 -Action Create
```

### 現在実装済みの機能

- ✅ シンボリックリンク管理スクリプト (`scripts/symlink.sh` - Linux/WSL/macOS)
- ✅ Windows PowerShell用シンボリックリンク管理 (`scripts/symlink.ps1`)
- ✅ Zsh設定 (`.zshrc`)
- ✅ Neovim設定 (`nvim/`)
- ✅ Tmux設定 (`.tmux.conf`)
- ✅ Wezterm設定 (`wezterm/`) - Windows/WSL対応
- ✅ WSL↔Windows ブラウザ統合

### 今後実装予定

- ⏳ OS自動判別スクリプト (`scripts/detect-os.sh`)
- ⏳ ブートストラップスクリプト (`bootstrap.sh`)
- ⏳ パッケージ管理・インストール自動化

## ディレクトリ構成

```
dotfiles/
├── bootstrap.sh              # メインセットアップスクリプト
├── install/                  # コンポーネント別インストールスクリプト
│   ├── common.sh            # 共有関数・ユーティリティ
│   ├── shell.sh             # シェル設定 (bash, zsh)
│   ├── editor.sh            # エディタ設定 (vim, emacs等)
│   ├── development.sh       # 開発ツールセットアップ
│   └── os-specific/         # プラットフォーム固有スクリプト
│       ├── wsl.sh
│       ├── macos.sh
│       └── linux.sh
├── config/                   # 設定ファイル群
│   ├── shell/               # シェル設定
│   │   ├── .zshrc           # Zsh設定 ✓ 実装済み
│   │   ├── .bashrc          # Bash設定
│   │   └── .profile         # Profile設定
│   ├── editor/              # エディタ設定
│   │   ├── nvim/            # Neovim設定 ✓ 実装済み
│   │   ├── .vimrc           # Vim設定
│   │   └── .emacs.d/        # Emacs設定
│   ├── git/                 # Git設定
│   │   └── .gitconfig       # Git設定ファイル
│   └── other/               # その他 dotfiles
│       ├── .tmux.conf       # Tmux設定 ✓ 実装済み
│       └── wezterm/         # Wezterm設定 ✓ 実装済み
├── scripts/                  # ユーティリティスクリプト
│   ├── detect-os.sh         # OS判別
│   ├── symlink.sh           # シンボリックリンク管理 ✓ 実装済み
│   └── utils.sh             # 共通ユーティリティ
└── docs/                     # ドキュメント
    ├── SETUP.md
    ├── TROUBLESHOOTING.md
    └── PLATFORMS.md
```

## 使用方法

### 初回セットアップ

```bash
# リポジトリをクローン
git clone https://github.com/masacham/dotfiles ~/.dotfiles
cd ~/.dotfiles

# シンボリックリンク作成（現在推奨）
./scripts/symlink.sh
```

### dotfiles の管理

**Linux/WSL:**
```bash
# 設定ファイルのシンボリックリンク作成
./scripts/symlink.sh

# シンボリックリンクを検証
./scripts/symlink.sh --verify

# すべてのシンボリックリンクを削除
./scripts/symlink.sh --remove
```

**Windows (PowerShell - 管理者権限で実行):**
```powershell
# シンボリックリンク作成
.\scripts\symlink.ps1 -Action Create

# シンボリックリンク検証
.\scripts\symlink.ps1 -Action Verify

# シンボリックリンク削除
.\scripts\symlink.ps1 -Action Remove
```

### 設定の更新

```bash
# 最新の変更をプル
cd ~/.dotfiles
git pull

# シンボリックリンク経由で自動反映されます
```

## プラットフォーム別の注意事項

### Windows (WSL 2)

セットアップスクリプトが WSL を自動検出し、Windows 固有の設定を適用します:
- Windows ファイルへのアクセス (`/mnt/c/`)
- Windows Terminal との統合
- 行末コード差異の処理 (LF vs CRLF)

**推奨セットアップ手順:**
```bash
# WSL 2 を有効化
wsl --set-default-version 2

# Microsoft Store から Ubuntu をインストール
# その後、Ubuntu ターミナルで:
git clone https://github.com/YOUR_USERNAME/dotfiles ~/.dotfiles
~/.dotfiles/bootstrap.sh
```

### macOS

macOS 固有の要件を自動で処理します:
- Homebrew によるパッケージ管理
- macOS 固有の設定
- Catalina 以降のデフォルトシェル (zsh) 対応

**事前準備（Homebrew インストール）:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Linux

Linux ディストリビューションを自動検出し、適切な設定を適用します:
- apt ベースシステム対応 (Ubuntu, Debian)
- 他のパッケージマネージャにも拡張可能

## 設定

### 環境変数

dotfiles ディレクトリに `.env.local` ファイルを作成して個人用設定を行えます:

```bash
# .env.local (Git では管理しない)
export EDITOR=nvim
export SHELL=/bin/zsh
export DOTFILES_SKIP_PACKAGES=true  # パッケージインストールをスキップ
```

## カスタマイズ

`config/` ディレクトリの設定ファイルを直接編集すると、シンボリックリンク経由で自動的にホームディレクトリに反映されます：

- シェル設定: `config/shell/` - `.zshrc`
- エディタ設定: `config/editor/` - `nvim/`、`.vimrc` など
- ターミナル設定: `config/other/` - `.tmux.conf`、`wezterm/` など
- Git設定: `config/git/` - `.gitconfig`

変更後は、シェルを再起動するか `source` コマンドで即座に反映できます。

## トラブルシューティング

### よくある問題

**スクリプトに実行権限がない**
```bash
chmod +x bootstrap.sh
chmod +x scripts/*.sh
chmod +x install/*.sh
```

**シンボリックリンク競合**
```bash
# 既存のリンクを確認
ls -la ~/

# 競合ファイルを削除
rm ~/.bashrc ~/.zshrc

# シンボリックリンクスクリプトを再実行
./scripts/symlink.sh
```

**パッケージインストール失敗**
```bash
# プラットフォームが正しく認識されているか確認
./scripts/detect-os.sh

# プラットフォーム固有のインストール試行
./install/os-specific/[プラットフォーム].sh
```

詳細は [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) を参照してください。

## 貢献

改善への貢献:

1. フィーチャーブランチを作成: `git checkout -b feature/my-improvement`
2. 変更を加えてテスト (可能ならマルチプラットフォーム対応)
3. 説明的なコミットメッセージ: `git commit -m "Add feature: description"`
4. フォークにプッシュ: `git push origin feature/my-improvement`
5. プルリクエストを作成

## テスト

異なる環境でセットアップをテスト:

```bash
# WSL 2 でテスト
# macOS でテスト
# Linux でテスト

# すべてのシンボリックリンクが正しいか確認
./scripts/symlink.sh --verify

# シェル設定エラーをチェック
bash -n ~/.bashrc
zsh -n ~/.zshrc
```

## バックアップ

`./scripts/symlink.sh` 実行時に既存設定が自動的にバックアップされます：

```bash
# バックアップは ~/.dotfiles-backup/ に保存
ls -la ~/.dotfiles-backup/
```

## 環境

現在の開発環境：

- **OS**: Windows (WSL 2) + Linux + Windows Native
- **Terminal**: Wezterm (Windows/WSL), zsh (WSL/Linux)
- **Editor**: Neovim (LazyVim) - Windows/Linux対応
- **Multiplexer**: Tmux (Linux/WSL)
- **Shell**: Zsh (Linux/WSL), PowerShell 7+ (Windows)

---

**最終更新:** 2025年12月19日  
**対応プラットフォーム:** Windows (Native + WSL 2)、macOS、Linux