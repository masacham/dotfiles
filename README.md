# 🖥️ Masa's Dotfiles

> **Masa's Developer Environment Toolkit**  
> 効率的な開発環境を構築するための設定ファイル集

## 🌟 特徴

- **Windows,Linux環境どちらにも対応**
- **便利なシェルプラグイン** (zsh,pwsh)
- **モダンなターミナル環境** (wezterm)
- **VSCodeとNeovimのキーバインド統合** (変わらない使い心地)

---

## 📚 目次

1. [🔧 含まれるツール](#-含まれるツール)
2. [📂 ファイル構成](#-ファイル構成)
3. [⚙️ インストール方法](#️-インストール方法)

---

## 🔧 含まれるツール

### 主要設定

| カテゴリ       | ツールリスト                          |
|----------------|---------------------------------------|
| Shell          | Zsh, Bash, Starship                   |
| エディタ       | Neovim, VSCode                        |
| ターミナル     | Tmux, Alacritty                       |
| バージョン管理 | Git, GitHub CLI                       |

### ユーティリティ

```text
- fzf (ファジーファインダー)
- ripgrep (高速grep)
...
```

---

## 📂 ファイル構成

```tree
.
├── .config/         
│   ├── nvim/         # Neovim設定
│   └── wezterm/      # プロンプト設定
├── home/             # ホームディレクトリ設定
│   ├── .zshrc        # Zsh設定
│   └── .tmux.conf    # Tmux設定
└── scripts/          # ユーティリティスクリプト
    └── install.sh    # 自動インストーラー
```

---

## ⚙️ インストール方法

### Windows

```powershell
```

### Linux

```bash
```

---

## スクリーンショット

### ターミナルプレビュー

![Terminal Preview](./screenshots/terminal.png)

### Neovimデモ

![Neovim Demo](./screenshots/nvim.gif)
