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

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

### 手動セットアップ

```bash
# リポジトリのクローン
git clone https://github.com/YOUR_USERNAME/dotfiles ~/.dotfiles
cd ~/.dotfiles

# ブートストラップスクリプトを確認
cat bootstrap.sh

# ブートストラップスクリプト実行
./bootstrap.sh

# または個別コンポーネントをインストール
./install/shell.sh
./install/editor.sh
./install/development.sh
```

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
│   ├── shell/               # シェル rc ファイル
│   │   ├── .bashrc
│   │   ├── .zshrc
│   │   └── .profile
│   ├── editor/              # エディタ設定
│   │   ├── .vimrc
│   │   ├── .config/nvim/
│   │   └── .emacs.d/
│   ├── git/                 # Git設定
│   │   └── .gitconfig
│   └── other/               # その他 dotfiles
├── scripts/                  # ユーティリティスクリプト
│   ├── detect-os.sh        # OS判別
│   ├── symlink.sh          # シンボリックリンク管理
│   └── utils.sh            # 共通ユーティリティ
└── docs/                     # ドキュメント
    ├── SETUP.md
    ├── TROUBLESHOOTING.md
    └── PLATFORMS.md
```

## 使用方法

### 初回セットアップ

```bash
# フル設定
./bootstrap.sh --all

# インタラクティブモード（コンポーネント選択）
./bootstrap.sh --interactive

# プラットフォーム指定セットアップ
./bootstrap.sh --platform wsl
./bootstrap.sh --platform macos
./bootstrap.sh --platform linux
```

### 設定の更新

```bash
# 最新の変更をプル
cd ~/.dotfiles
git pull

# ブートストラップを再実行して更新を適用
./bootstrap.sh --sync
```

### dotfiles の管理

```bash
# 設定ファイルのシンボリックリンク作成
./scripts/symlink.sh

# すべてのシンボリックリンクを削除
./scripts/symlink.sh --remove

# シンボリックリンクを検証
./scripts/symlink.sh --verify
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

### カスタマイズ

`config/` ディレクトリの設定ファイルを直接編集:
- シェル設定: `config/shell/`
- エディタ設定: `config/editor/`
- バージョン管理: `config/git/`

`source ~/.bashrc` またはシェル再起動後に変更が反映されます。

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

初回実行前に既存設定のバックアップが自動作成されます:

```bash
# バックアップは ~/.dotfiles-backup/ に保存
ls -la ~/.dotfiles-backup/
```

## リソース

- [dotfiles guide](https://dotfiles.github.io/)
- [Thoughtbot dotfiles](https://github.com/thoughtbot/dotfiles)
- [WSL 2 ドキュメント](https://docs.microsoft.com/ja-jp/windows/wsl/install)
- [Homebrew ドキュメント](https://brew.sh/index_ja)

## ライセンス

[MIT、Apache 2.0 など]

## サポート

問題や質問がある場合:
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) を確認
- [Issue](https://github.com/YOUR_USERNAME/dotfiles/issues) を作成
- [PLATFORMS.md](docs/PLATFORMS.md) でプラットフォーム固有の詳細を確認

---

**最終更新:** 2025年12月18日  
**動作確認済み:** Windows (WSL 2)、macOS、Linux (Ubuntu)