#!/bin/bash
# ================================================
# YTDown - YouTube Downloader Installation Script
# Version: 1.0.0
# Author: Rg100152
# License: MIT
# ================================================

set -e
set -u
set -o pipefail

# ================================================
# COLOR DEFINITIONS
# ================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# ================================================
# GLOBAL VARIABLES
# ================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="${HOME}/.ytdown"
DATA_DIR="${HOME}/.local/share/ytdown"
LOG_FILE="${HOME}/ytdown_install.log"
TEMP_DIR="/tmp/ytdown_install_$$"
VERSION="1.0.0"
PYTHON_CMD="python3"
PIP_CMD="pip3"

# Dependencies
REQUIRED_PACKAGES=("python3" "pip3" "git" "ffmpeg" "wget" "curl")
PYTHON_PACKAGES=("thinker" "yt-dlp" "requests" "pillow" "pathlib")

# Platform detection
OS_TYPE="unknown"
ARCH_TYPE="unknown"
PACKAGE_MANAGER="unknown"

# ================================================
# LOGGING FUNCTIONS
# ================================================
log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "[${timestamp}] $1" | tee -a "$LOG_FILE"
}

log_info() {
    log "${BLUE}[INFO]${NC} $1"
}

log_success() {
    log "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    log "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    log "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo ""
    log "${BOLD}${MAGENTA}═══════════════════════════════════════════════════════${NC}"
    log "${BOLD}${WHITE}  $1${NC}"
    log "${BOLD}${MAGENTA}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

# ================================================
# BANNER DISPLAY
# ================================================
show_banner() {
    echo ""
    echo -e "${CYAN}${BOLD}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║                                                       ║${NC}"
    echo -e "${GREEN}${BOLD}║   ██╗   ██╗████████╗██████╗  ██████╗ ██╗    ║${NC}"
    echo -e "${GREEN}${BOLD}║   ╚██╗ ██╔╝╚══██╔══╝██╔══██╗██╔═══██╗██║    ║${NC}"
    echo -e "${YELLOW}${BOLD}║    ╚████╔╝    ██║   ██║  ██║██║   ██║██║    ║${NC}"
    echo -e "${YELLOW}${BOLD}║     ╚██╔╝     ██║   ██║  ██║██║   ██║██║    ║${NC}"
    echo -e "${MAGENTA}${BOLD}║      ██║      ██║   ██████╔╝╚██████╔╝███████╗║${NC}"
    echo -e "${MAGENTA}${BOLD}║      ╚═╝      ╚═╝   ╚═════╝  ╚═════╝ ╚══════╝║${NC}"
    echo -e "${CYAN}${BOLD}║                                                       ║${NC}"
    echo -e "${CYAN}${BOLD}║          YOUTUBE DOWNLOADER v${VERSION}               ║${NC}"
    echo -e "${CYAN}${BOLD}║          By Rg100152                                ║${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}${BOLD}Welcome to YTDown Installation Script${NC}"
    echo -e "${WHITE}This script will install YTDown on your system${NC}"
    echo ""
}

# ================================================
# SYSTEM DETECTION
# ================================================
detect_os() {
    log_info "Detecting operating system..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS_TYPE="linux"
        log_success "Linux detected"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS_TYPE="macos"
        log_success "macOS detected"
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        OS_TYPE="freebsd"
        log_success "FreeBSD detected"
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        OS_TYPE="windows"
        log_success "Windows detected (Cygwin/MSYS)"
    elif [[ -d "/data/data/com.termux" ]]; then
        OS_TYPE="termux"
        log_success "Termux (Android) detected"
    else
        OS_TYPE="unknown"
        log_warning "Unknown operating system: $OSTYPE"
    fi
    
    # Detect architecture
    ARCH_TYPE=$(uname -m)
    log_info "Architecture: $ARCH_TYPE"
}

detect_package_manager() {
    log_info "Detecting package manager..."
    
    if [[ "$OS_TYPE" == "termux" ]]; then
        PACKAGE_MANAGER="pkg"
        log_success "Termux package manager detected: pkg"
    elif command -v apt-get &> /dev/null; then
        PACKAGE_MANAGER="apt"
        log_success "APT package manager detected"
    elif command -v yum &> /dev/null; then
        PACKAGE_MANAGER="yum"
        log_success "YUM package manager detected"
    elif command -v dnf &> /dev/null; then
        PACKAGE_MANAGER="dnf"
        log_success "DNF package manager detected"
    elif command -v pacman &> /dev/null; then
        PACKAGE_MANAGER="pacman"
        log_success "Pacman package manager detected"
    elif command -v zypper &> /dev/null; then
        PACKAGE_MANAGER="zypper"
        log_success "Zypper package manager detected"
    elif command -v brew &> /dev/null; then
        PACKAGE_MANAGER="brew"
        log_success "Homebrew package manager detected"
    elif command -v emerge &> /dev/null; then
        PACKAGE_MANAGER="emerge"
        log_success "Portage package manager detected"
    else
        PACKAGE_MANAGER="unknown"
        log_warning "No known package manager detected"
    fi
}

# ================================================
# PRIVILEGE CHECK
# ================================================
check_root() {
    log_info "Checking privileges..."
    
    if [[ $EUID -eq 0 ]]; then
        log_success "Running as root"
        return 0
    else
        log_warning "Not running as root. Some operations may require sudo."
        return 1
    fi
}

# ================================================
# DEPENDENCY INSTALLATION
# ================================================
install_system_dependencies() {
    log_header "Installing System Dependencies"
    
    local missing_packages=()
    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        if ! command -v "$pkg" &> /dev/null; then
            missing_packages+=("$pkg")
        fi
    done
    
    if [[ ${#missing_packages[@]} -eq 0 ]]; then
        log_success "All system dependencies are already installed"
        return 0
    fi
    
    log_info "Missing packages: ${missing_packages[*]}"
    log_info "Installing missing packages..."
    
    case "$PACKAGE_MANAGER" in
        pkg)
            pkg update -y
            pkg install -y python ffmpeg git wget curl
            ;;
        apt)
            sudo apt-get update -y
            sudo apt-get install -y python3 python3-pip git ffmpeg wget curl
            ;;
        yum)
            sudo yum install -y python3 python3-pip git ffmpeg wget curl
            ;;
        dnf)
            sudo dnf install -y python3 python3-pip git ffmpeg wget curl
            ;;
        pacman)
            sudo pacman -Syu --noconfirm python python-pip git ffmpeg wget curl
            ;;
        zypper)
            sudo zypper install -y python3 python3-pip git ffmpeg wget curl
            ;;
        brew)
            brew update
            brew install python git ffmpeg wget curl
            ;;
        emerge)
            sudo emerge --ask --noreplace dev-lang/python dev-vcs/git media-video/ffmpeg net-misc/wget net-misc/curl
            ;;
        *)
            log_error "Cannot install dependencies automatically"
            log_error "Please manually install: ${missing_packages[*]}"
            return 1
            ;;
    esac
    
    log_success "System dependencies installed successfully"
}

install_python_dependencies() {
    log_header "Installing Python Dependencies"
    
    log_info "Upgrading pip..."
    $PYTHON_CMD -m pip install --upgrade pip setuptools wheel || {
        log_warning "Could not upgrade pip, continuing with existing version"
    }
    
    log_info "Installing Python packages..."
    for pkg in "${PYTHON_PACKAGES[@]}"; do
        log_info "Installing $pkg..."
        $PIP_CMD install --upgrade "$pkg" || {
            log_warning "Failed to install $pkg, trying without upgrade..."
            $PIP_CMD install "$pkg" || {
                log_error "Failed to install $pkg"
                return 1
            }
        }
    done
    
    log_success "Python dependencies installed successfully"
}

# ================================================
# MAIN APPLICATION INSTALLATION
# ================================================
install_application() {
    log_header "Installing YTDown Application"
    
    # Create necessary directories
    log_info "Creating directories..."
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$DATA_DIR"
    mkdir -p "$TEMP_DIR"
    
    # Copy main application
    log_info "Copying application files..."
    if [[ -f "$SCRIPT_DIR/ytdown.py" ]]; then
        cp "$SCRIPT_DIR/ytdown.py" "$TEMP_DIR/ytdown.py"
        log_success "Application file copied"
    else
        log_error "ytdown.py not found in current directory"
        return 1
    fi
    
    # Make executable
    chmod +x "$TEMP_DIR/ytdown.py"
    
    # Install to system
    log_info "Installing to $INSTALL_DIR..."
    if check_root; then
        cp "$TEMP_DIR/ytdown.py" "$INSTALL_DIR/ytdown"
        chmod 755 "$INSTALL_DIR/ytdown"
        log_success "Installed to $INSTALL_DIR/ytdown"
    else
        sudo cp "$TEMP_DIR/ytdown.py" "$INSTALL_DIR/ytdown"
        sudo chmod 755 "$INSTALL_DIR/ytdown"
        log_success "Installed to $INSTALL_DIR/ytdown (with sudo)"
    fi
    
    # Create symlink for easy access
    if [[ -d "/usr/local/bin" ]]; then
        ln -sf "$INSTALL_DIR/ytdown" /usr/local/bin/ytdown 2>/dev/null || true
    fi
    
    # Create configuration file
    log_info "Creating default configuration..."
    if [[ ! -f "$CONFIG_DIR/config.json" ]]; then
        cat > "$CONFIG_DIR/config.json" << EOF
{
    "version": "$VERSION",
    "download_dir": "$HOME/Downloads",
    "default_format": "mp4",
    "default_quality": "best",
    "max_history": 50,
    "theme": "dark",
    "auto_update": true,
    "log_level": "info",
    "api_enabled": false,
    "api_port": 8080,
    "ffmpeg_path": "/usr/bin/ffmpeg",
    "ytdlp_path": "/usr/local/bin/yt-dlp",
    "proxy_settings": {
        "enabled": false,
        "http_proxy": "",
        "https_proxy": ""
    },
    "download_settings": {
        "max_retries": 3,
        "timeout": 300,
        "concurrent_downloads": 1,
        "chunk_size": 1048576
    },
    "history_settings": {
        "enabled": true,
        "max_entries": 50,
        "save_path": "$DATA_DIR/history.json"
    }
}
EOF
        log_success "Default configuration created at $CONFIG_DIR/config.json"
    else
        log_info "Configuration already exists, skipping creation"
    fi
    
    # Create desktop entry for Linux
    if [[ "$OS_TYPE" == "linux" ]]; then
        log_info "Creating desktop entry..."
        if [[ -d "/usr/share/applications" ]]; then
            cat > "/tmp/ytdown.desktop" << EOF
[Desktop Entry]
Name=YTDown
Comment=YouTube Video Downloader
Exec=ytdown
Icon=ytdown
Terminal=true
Type=Application
Categories=AudioVideo;Network;
Keywords=youtube;download;video;
EOF
            if check_root; then
                cp "/tmp/ytdown.desktop" "/usr/share/applications/"
                log_success "Desktop entry created"
            else
                sudo cp "/tmp/ytdown.desktop" "/usr/share/applications/"
                log_success "Desktop entry created (with sudo)"
            fi
        fi
    fi
    
    log_success "Application installed successfully"
}

# ================================================
# BASH COMPLETION
# ================================================
install_bash_completion() {
    log_header "Installing Bash Completion"
    
    local completion_script="$TEMP_DIR/ytdown-completion.bash"
    
    cat > "$completion_script" << 'EOF'
_ytdown_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-h --help -v --version -u --url -f --format -q --quality -o --output -l --list -d --download -c --cancel -h --history --config"
    
    case "${prev}" in
        -f|--format)
            COMPREPLY=( $(compgen -W "mp4 webm audio" -- ${cur}) )
            return 0
            ;;
        -q|--quality)
            COMPREPLY=( $(compgen -W "best high medium low" -- ${cur}) )
            return 0
            ;;
        -u|--url)
            return 0
            ;;
        -o|--output)
            COMPREPLY=( $(compgen -d -- ${cur}) )
            return 0
            ;;
        *)
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
    esac
}

complete -F _ytdown_completion ytdown
EOF
    
    log_info "Installing bash completion..."
    if [[ -d "/etc/bash_completion.d" ]]; then
        if check_root; then
            cp "$completion_script" "/etc/bash_completion.d/ytdown"
            log_success "Bash completion installed globally"
        else
            sudo cp "$completion_script" "/etc/bash_completion.d/ytdown"
            log_success "Bash completion installed globally (with sudo)"
        fi
    elif [[ -d "$HOME/.bash_completion.d" ]]; then
        mkdir -p "$HOME/.bash_completion.d"
        cp "$completion_script" "$HOME/.bash_completion.d/ytdown"
        echo "source $HOME/.bash_completion.d/ytdown" >> "$HOME/.bashrc"
        log_success "Bash completion installed for current user"
    else
        log_warning "Could not install bash completion"
    fi
}

# ================================================
# ZSH COMPLETION
# ================================================
install_zsh_completion() {
    log_header "Installing ZSH Completion"
    
    local completion_script="$TEMP_DIR/_ytdown"
    
    cat > "$completion_script" << 'EOF'
#compdef ytdown

_ytdown() {
    local -a commands
    local -a formats
    local -a qualities
    
    commands=(
        '--help:Show help message'
        '--version:Show version info'
        '--url:Specify YouTube URL'
        '--format:Specify output format'
        '--quality:Specify video quality'
        '--output:Specify output directory'
        '--list:List available formats'
        '--download:Start download'
        '--cancel:Cancel current download'
        '--history:Show download history'
        '--config:Edit configuration'
    )
    
    formats=('mp4' 'webm' 'audio')
    qualities=('best' 'high' 'medium' 'low')
    
    _arguments -s \
        '-h[Show help]' \
        '-v[Show version]' \
        '-u[Specify YouTube URL]:url:_urls' \
        '-f[Specify format]:format:(${formats})' \
        '-q[Specify quality]:quality:(${qualities})' \
        '-o[Specify output directory]:directory:_directories' \
        '-l[List available formats]' \
        '-d[Start download]' \
        '-c[Cancel current download]' \
        '--history[Show download history]' \
        '--config[Edit configuration]'
}

_ytdown "$@"
EOF
    
    log_info "Installing ZSH completion..."
    if [[ -d "/usr/share/zsh/site-functions" ]]; then
        if check_root; then
            cp "$completion_script" "/usr/share/zsh/site-functions/_ytdown"
            log_success "ZSH completion installed globally"
        else
            sudo cp "$completion_script" "/usr/share/zsh/site-functions/_ytdown"
            log_success "ZSH completion installed globally (with sudo)"
        fi
    elif [[ -d "$HOME/.zsh/completion" ]]; then
        mkdir -p "$HOME/.zsh/completion"
        cp "$completion_script" "$HOME/.zsh/completion/_ytdown"
        echo "fpath=($HOME/.zsh/completion \$fpath)" >> "$HOME/.zshrc"
        echo "autoload -Uz compinit && compinit" >> "$HOME/.zshrc"
        log_success "ZSH completion installed for current user"
    else
        log_warning "Could not install ZSH completion"
    fi
}

# ================================================
# MAN PAGE INSTALLATION
# ================================================
install_man_page() {
    log_header "Installing Man Page"
    
    local man_file="$TEMP_DIR/ytdown.1"
    
    cat > "$man_file" << 'EOF'
.TH YTDOWN 1 "2024-01-01" "1.0.0" "YTDown User Manual"
.SH NAME
ytdown \- YouTube video downloader with GUI and CLI
.SH SYNOPSIS
.B ytdown
[OPTIONS]
.SH DESCRIPTION
YTDown is a powerful YouTube video downloader with both GUI and CLI interfaces.
It supports multiple formats, qualities, and provides progress tracking.
.SH OPTIONS
.TP
.BR \-h ", " \-\-help
Show help message and exit
.TP
.BR \-v ", " \-\-version
Show version information
.TP
.BR \-u ", " \-\-url " <URL>"
Specify YouTube video URL
.TP
.BR \-f ", " \-\-format " <FORMAT>"
Specify output format (mp4, webm, audio)
.TP
.BR \-q ", " \-\-quality " <QUALITY>"
Specify video quality (best, high, medium, low)
.TP
.BR \-o ", " \-\-output " <DIR>"
Specify output directory
.TP
.BR \-l ", " \-\-list
List available formats for the video
.TP
.BR \-d ", " \-\-download
Start download process
.TP
.BR \-c ", " \-\-cancel
Cancel current download
.TP
.BR \-\-history
Show download history
.TP
.BR \-\-config
Edit configuration file
.SH EXAMPLES
.B ytdown \-u "https://www.youtube.com/watch?v=example"
.B ytdown \-u "https://..." \-f mp4 \-q high \-o ~/Downloads
.B ytdown \-\-config
.SH FILES
.B ~/.ytdown/config.json
Configuration file
.B ~/.local/share/ytdown/history.json
Download history
.SH AUTHOR
Written by Rg100152
.SH REPORTING BUGS
https://github.com/Rg100152/Ytdown/issues
.SH COPYRIGHT
MIT License
EOF
    
    log_info "Installing man page..."
    if [[ -d "/usr/share/man/man1" ]]; then
        if check_root; then
            cp "$man_file" "/usr/share/man/man1/ytdown.1"
            gzip -f "/usr/share/man/man1/ytdown.1" 2>/dev/null || true
            log_success "Man page installed"
        else
            sudo cp "$man_file" "/usr/share/man/man1/ytdown.1"
            sudo gzip -f "/usr/share/man/man1/ytdown.1" 2>/dev/null || true
            log_success "Man page installed (with sudo)"
        fi
    else
        log_warning "Could not install man page"
    fi
}

# ================================================
# PATH VALIDATION
# ================================================
validate_installation() {
    log_header "Validating Installation"
    
    local errors=0
    
    # Check if ytdown command is available
    log_info "Checking ytdown command..."
    if command -v ytdown &> /dev/null; then
        log_success "ytdown command is available"
    else
        log_error "ytdown command not found in PATH"
        errors=$((errors + 1))
    fi
    
    # Check Python packages
    log_info "Checking Python packages..."
    for pkg in "${PYTHON_PACKAGES[@]}"; do
        if $PYTHON_CMD -c "import $pkg" &> /dev/null; then
            log_success "$pkg is installed"
        else
            log_error "$pkg is not installed"
            errors=$((errors + 1))
        fi
    done
    
    # Check configuration
    log_info "Checking configuration..."
    if [[ -f "$CONFIG_DIR/config.json" ]]; then
        log_success "Configuration file exists"
    else
        log_error "Configuration file missing"
        errors=$((errors + 1))
    fi
    
    # Check if yt-dlp is available
    log_info "Checking yt-dlp..."
    if command -v yt-dlp &> /dev/null; then
        log_success "yt-dlp is available"
    elif $PYTHON_CMD -c "import yt_dlp" &> /dev/null; then
        log_success "yt-dlp Python module is available"
    else
        log_error "yt-dlp is not available"
        errors=$((errors + 1))
    fi
    
    if [[ $errors -eq 0 ]]; then
        log_success "Installation validated successfully!"
        return 0
    else
        log_warning "Installation validation completed with $errors errors"
        return 1
    fi
}

# ================================================
# POST INSTALLATION
# ================================================
post_install_message() {
    log_header "Installation Complete!"
    
    echo -e "${GREEN}${BOLD}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║                                                       ║${NC}"
    echo -e "${WHITE}${BOLD}║  🎉 YTDown has been successfully installed!          ║${NC}"
    echo -e "${WHITE}${BOLD}║                                                       ║${NC}"
    echo -e "${CYAN}${BOLD}║  Quick Start:                                         ║${NC}"
    echo -e "${CYAN}${BOLD}║    ytdown -u <youtube_url>                           ║${NC}"
    echo -e "${CYAN}${BOLD}║                                                       ║${NC}"
    echo -e "${YELLOW}${BOLD}║  Usage Examples:                                     ║${NC}"
    echo -e "${YELLOW}${BOLD}║    ytdown -h               # Show help              ║${NC}"
    echo -e "${YELLOW}${BOLD}║    ytdown --config         # Edit configuration     ║${NC}"
    echo -e "${YELLOW}${BOLD}║    ytdown --history        # View download history  ║${NC}"
    echo -e "${YELLOW}${BOLD}║                                                       ║${NC}"
    echo -e "${MAGENTA}${BOLD}║  Configuration:                                      ║${NC}"
    echo -e "${MAGENTA}${BOLD}║    ~/.ytdown/config.json                           ║${NC}"
    echo -e "${MAGENTA}${BOLD}║                                                       ║${NC}"
    echo -e "${GREEN}${BOLD}║  Report Issues:                                       ║${NC}"
    echo -e "${GREEN}${BOLD}║    https://github.com/Rg100152/Ytdown/issues         ║${NC}"
    echo -e "${GREEN}${BOLD}║                                                       ║${NC}"
    echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ================================================
# CLEANUP
# ================================================
cleanup() {
    log_info "Cleaning up temporary files..."
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
        log_success "Temporary files removed"
    fi
    log_info "Installation log saved at: $LOG_FILE"
}

# ================================================
# UNINSTALL FUNCTION
# ================================================
uninstall_ytdown() {
    log_header "Uninstalling YTDown"
    
    log_info "Removing executable..."
    if [[ -f "$INSTALL_DIR/ytdown" ]]; then
        if check_root; then
            rm -f "$INSTALL_DIR/ytdown"
        else
            sudo rm -f "$INSTALL_DIR/ytdown"
        fi
        log_success "Executable removed"
    fi
    
    log_info "Removing configuration..."
    if [[ -d "$CONFIG_DIR" ]]; then
        read -p "Remove configuration directory? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$CONFIG_DIR"
            log_success "Configuration removed"
        else
            log_info "Configuration kept"
        fi
    fi
    
    log_info "Removing data directory..."
    if [[ -d "$DATA_DIR" ]]; then
        read -p "Remove data directory? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$DATA_DIR"
            log_success "Data directory removed"
        else
            log_info "Data directory kept"
        fi
    fi
    
    log_info "Removing completion scripts..."
    rm -f "/etc/bash_completion.d/ytdown" 2>/dev/null || true
    rm -f "/usr/share/zsh/site-functions/_ytdown" 2>/dev/null || true
    rm -f "/usr/share/man/man1/ytdown.1" 2>/dev/null || true
    rm -f "/usr/share/man/man1/ytdown.1.gz" 2>/dev/null || true
    
    log_success "YTDown uninstalled successfully!"
}

# ================================================
# MAIN MENU
# ================================================
show_menu() {
    echo ""
    echo -e "${BOLD}${WHITE}Select an option:${NC}"
    echo -e "${CYAN}1)${NC} Install YTDown"
    echo -e "${CYAN}2)${NC} Uninstall YTDown"
    echo -e "${CYAN}3)${NC} Update YTDown"
    echo -e "${CYAN}4)${NC} Exit"
    echo ""
    read -p "Enter your choice [1-4]: " choice
    
    case "$choice" in
        1)
            main_install
            ;;
        2)
            uninstall_ytdown
            ;;
        3)
            update_ytdown
            ;;
        4|"")
            log_info "Exiting..."
            exit 0
            ;;
        *)
            log_error "Invalid choice"
            show_menu
            ;;
    esac
}

# ================================================
# MAIN INSTALLATION FUNCTION
# ================================================
main_install() {
    log_header "Starting YTDown Installation"
    
    # Check if already installed
    if command -v ytdown &> /dev/null; then
        log_warning "YTDown is already installed"
        read -p "Reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled"
            return 0
        fi
    fi
    
    # Start installation
    detect_os
    detect_package_manager
    check_root
    
    install_system_dependencies || {
        log_error "System dependency installation failed"
        return 1
    }
    
    install_python_dependencies || {
        log_error "Python dependency installation failed"
        return 1
    }
    
    install_application || {
        log_error "Application installation failed"
        return 1
    }
    
    install_bash_completion
    install_zsh_completion
    install_man_page
    
    validate_installation
    
    post_install_message
    cleanup
    
    log_success "Installation completed successfully!"
    return 0
}

# ================================================
# UPDATE FUNCTION
# ================================================
update_ytdown() {
    log_header "Updating YTDown"
    
    log_info "Checking for updates..."
    cd "$SCRIPT_DIR" || {
        log_error "Cannot access script directory"
        return 1
    }
    
    if [[ -d ".git" ]]; then
        log_info "Git repository detected, pulling latest changes..."
        git pull origin main || {
            log_warning "Git pull failed, continuing..."
        }
    else
        log_info "Downloading latest version..."
        local tmp_dir="/tmp/ytdown_update_$$"
        mkdir -p "$tmp_dir"
        cd "$tmp_dir"
        
        # Download from GitHub
        wget -q "https://raw.githubusercontent.com/Rg100152/Ytdown/main/ytdown.py" -O ytdown.py || {
            log_error "Failed to download latest version"
            rm -rf "$tmp_dir"
            return 1
        }
        
        # Replace old version
        if check_root; then
            cp ytdown.py "$INSTALL_DIR/ytdown"
        else
            sudo cp ytdown.py "$INSTALL_DIR/ytdown"
        fi
        chmod 755 "$INSTALL_DIR/ytdown"
        
        cd - > /dev/null
        rm -rf "$tmp_dir"
    fi
    
    log_success "Update completed!"
}

# ================================================
# TRAP HANDLERS
# ================================================
trap_handler() {
    log_error "Installation interrupted!"
    cleanup
    exit 1
}

trap trap_handler SIGINT SIGTERM

# ================================================
# SCRIPT ENTRY POINT
# ================================================
main() {
    # Check if running with --uninstall
    if [[ "$1" == "--uninstall" || "$1" == "-u" ]]; then
        uninstall_ytdown
        exit 0
    fi
    
    # Check if running with --update
    if [[ "$1" == "--update" ]]; then
        update_ytdown
        exit 0
    fi
    
    # Show banner
    show_banner
    
    # Check if script is running from correct location
    if [[ ! -f "$SCRIPT_DIR/ytdown.py" ]]; then
        log_error "ytdown.py not found in current directory"
        log_error "Please run this script from the YTDown repository directory"
        exit 1
    fi
    
    # Show interactive menu or run installation directly
    if [[ "$1" == "--auto" ]]; then
        main_install
    else
        show_menu
    fi
}

# Check if any arguments passed
if [[ $# -gt 0 ]]; then
    main "$@"
else
    main
fi

# ================================================
# END OF SCRIPT
# ================================================
