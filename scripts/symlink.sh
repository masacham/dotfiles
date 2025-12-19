#!/bin/bash

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
BACKUP_DIR="${HOME}/.dotfiles-backup"

# Detect OS
detect_os() {
    if grep -qi microsoft /proc/version &> /dev/null; then
        echo "wsl"
    elif grep -qi "^ID=" /etc/os-release 2>/dev/null | grep -q "ubuntu\|debian"; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Help function
show_help() {
    cat << HELP
Usage: symlink.sh [OPTIONS]

OPTIONS:
    --remove        Remove all symlinks
    --verify        Verify symlinks
    -h, --help      Show this help message

Default behavior: Create symlinks
Current OS detected: $OS
HELP
}

# Create backup directory
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${GREEN}✓${NC} Backup directory created: $BACKUP_DIR"
    fi
}

# Backup existing file
backup_file() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup_path="$BACKUP_DIR/$(basename "$target")"
        cp -r "$target" "$backup_path"
        echo -e "${YELLOW}→${NC} Backed up: $target"
    fi
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ ! -e "$source" ]; then
        echo -e "${RED}✗${NC} Source not found: $source"
        return 1
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Remove existing file/link
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        backup_file "$target"
        rm -r "$target"
    fi
    
    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓${NC} Symlink created: $target -> $source"
}

# Remove symlink
remove_symlink() {
    local target="$1"
    if [ -L "$target" ]; then
        rm "$target"
        echo -e "${GREEN}✓${NC} Symlink removed: $target"
    fi
}

# Verify symlink
verify_symlink() {
    local target="$1"
    if [ -L "$target" ]; then
        local link_target=$(readlink "$target")
        echo -e "${GREEN}✓${NC} $target -> $link_target"
        return 0
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}→${NC} $target (regular file/directory)"
        return 0
    else
        echo -e "${RED}✗${NC} $target (not found)"
        return 1
    fi
}

# Create symlinks for Linux/WSL
create_symlinks_linux() {
    echo -e "${YELLOW}Creating symlinks for Linux/WSL...${NC}\n"
    
    # Shell config
    create_symlink "$DOTFILES_DIR/config/shell/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/config/shell/.bashrc" "$HOME/.bashrc" 2>/dev/null || true
    create_symlink "$DOTFILES_DIR/config/shell/.profile" "$HOME/.profile" 2>/dev/null || true
    
    # Editor config
    create_symlink "$DOTFILES_DIR/config/editor/nvim" "$HOME/.config/nvim"
    create_symlink "$DOTFILES_DIR/config/editor/.vimrc" "$HOME/.vimrc" 2>/dev/null || true
    create_symlink "$DOTFILES_DIR/config/editor/.emacs.d" "$HOME/.emacs.d" 2>/dev/null || true
    
    # Git config
    create_symlink "$DOTFILES_DIR/config/git/.gitconfig" "$HOME/.gitconfig" 2>/dev/null || true
    
    # Terminal config
    create_symlink "$DOTFILES_DIR/config/other/.tmux.conf" "$HOME/.tmux.conf"
    create_symlink "$DOTFILES_DIR/config/other/wezterm" "$HOME/.config/wezterm" 2>/dev/null || true
}

# Create symlinks for WSL (also handle Windows paths)
create_symlinks_wsl() {
    echo -e "${BLUE}[WSL Mode]${NC} Creating symlinks...\n"
    create_symlinks_linux
    
    # Additional WSL-specific setup
    echo -e "\n${YELLOW}WSL environment detected.${NC}"
    echo -e "For Windows Neovim/Wezterm, manually configure or use Windows paths."
}

# Create symlinks for macOS
create_symlinks_macos() {
    echo -e "${YELLOW}Creating symlinks for macOS...${NC}\n"
    
    # Shell config
    create_symlink "$DOTFILES_DIR/config/shell/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/config/shell/.bashrc" "$HOME/.bashrc" 2>/dev/null || true
    
    # Editor config
    create_symlink "$DOTFILES_DIR/config/editor/nvim" "$HOME/.config/nvim"
    create_symlink "$DOTFILES_DIR/config/editor/.vimrc" "$HOME/.vimrc" 2>/dev/null || true
    
    # Git config
    create_symlink "$DOTFILES_DIR/config/git/.gitconfig" "$HOME/.gitconfig" 2>/dev/null || true
    
    # Terminal config
    create_symlink "$DOTFILES_DIR/config/other/.tmux.conf" "$HOME/.tmux.conf"
}

# Remove symlinks
remove_symlinks() {
    echo -e "${YELLOW}Removing symlinks...${NC}\n"
    
    remove_symlink "$HOME/.zshrc"
    remove_symlink "$HOME/.bashrc"
    remove_symlink "$HOME/.profile"
    remove_symlink "$HOME/.config/nvim"
    remove_symlink "$HOME/.vimrc"
    remove_symlink "$HOME/.emacs.d"
    remove_symlink "$HOME/.gitconfig"
    remove_symlink "$HOME/.tmux.conf"
    remove_symlink "$HOME/.config/wezterm"
    
    echo -e "\n${GREEN}Done!${NC}"
}

# Verify symlinks
verify_symlinks() {
    echo -e "${YELLOW}Verifying symlinks...${NC}\n"
    
    verify_symlink "$HOME/.zshrc"
    verify_symlink "$HOME/.bashrc"
    verify_symlink "$HOME/.profile"
    verify_symlink "$HOME/.config/nvim"
    verify_symlink "$HOME/.vimrc"
    verify_symlink "$HOME/.emacs.d"
    verify_symlink "$HOME/.gitconfig"
    verify_symlink "$HOME/.tmux.conf"
    verify_symlink "$HOME/.config/wezterm"
    
    echo ""
}

# Main operations
case "${1:-}" in
    --remove)
        remove_symlinks
        ;;
    --verify)
        verify_symlinks
        ;;
    -h|--help)
        show_help
        ;;
    *)
        create_backup_dir
        case "$OS" in
            wsl)
                create_symlinks_wsl
                ;;
            macos)
                create_symlinks_macos
                ;;
            linux|*)
                create_symlinks_linux
                ;;
        esac
        echo -e "\n${GREEN}Done!${NC}"
        ;;
esac
