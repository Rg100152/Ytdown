#!/data/data/com.termux/files/usr/bin/bash
# ================================================
# YTDown - Termux Installation Script
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
TERMUX_HOME="/data/data/com.termux/files/home"
PREFIX="/data/data/com.termux/files/usr"
BIN_DIR="$PREFIX/bin"
CONFIG_DIR="$TERMUX_HOME/.ytdown"
DATA_DIR="$TERMUX_HOME/.local/share/ytdown"
LOG_FILE="$TERMUX_HOME/ytdown_install.log"
TEMP_DIR="/tmp/ytdown_termux_$$"
VERSION="1.0.0"
PYTHON_CMD="python"
PIP_CMD="pip"

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
    echo -e "${CYAN}${BOLD}║     TERMUX EDITION v${VERSION}                        ║${NC}"
    echo -e "${CYAN}${BOLD}║     By Rg100152                                     ║${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}${BOLD}Termux Installation Script for YTDown${NC}"
    echo -e "${WHITE}Designed for Android Termux Environment${NC}"
    echo ""
}

# ================================================
# TERMUX ENVIRONMENT CHECK
# ================================================
check_termux() {
    log_header "Checking Termux Environment"
    
    # Check if running in Termux
    if [[ ! -d "/data/data/com.termux" ]]; then
        log_error "This script is designed for Termux on Android"
        log_error "Please run this script in Termux environment"
        exit 1
    fi
    
    log_success "Termux environment detected"
    
    # Check storage permissions
    if [[ ! -d "$TERMUX_HOME/storage" ]]; then
        log_warning "Storage access not configured"
        log_info "Please run: termux-setup-storage"
        log_info "Then restart this script"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Check internet connection
    log_info "Checking internet connection..."
    if ping -c 1 8.8.8.8 &> /dev/null; then
        log_success "Internet connection active"
    else
        log_warning "No internet connection detected"
        log_info "Please connect to internet before continuing"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# ================================================
# SYSTEM UPDATE
# ================================================
update_termux() {
    log_header "Updating Termux Packages"
    
    log_info "Updating package list..."
    pkg update -y || {
        log_error "Failed to update package list"
        return 1
    }
    
    log_info "Upgrading packages..."
    pkg upgrade -y || {
        log_warning "Package upgrade failed, continuing..."
    }
    
    log_success "Termux packages updated successfully"
}

# ================================================
# DEPENDENCY INSTALLATION
# ================================================
install_dependencies() {
    log_header "Installing Dependencies"
    
    local dependencies=(
        "python"
        "ffmpeg"
        "git"
        "wget"
        "curl"
        "openssl"
        "libxml2"
        "libxslt"
        "ncurses"
        "readline"
    )
    
    log_info "Installing required packages..."
    
    for pkg in "${dependencies[@]}"; do
        log_info "Installing $pkg..."
        pkg install -y "$pkg" || {
            log_warning "Failed to install $pkg, continuing..."
        }
    done
    
    # Install Python packages
    log_info "Installing Python packages..."
    
    # Upgrade pip
    $PYTHON_CMD -m pip install --upgrade pip || {
        log_warning "Failed to upgrade pip"
    }
    
    # Install required Python packages
    local python_packages=(
        "thinker"
        "yt-dlp"
        "requests"
        "pillow"
        "pathlib"
        "urllib3"
        "certifi"
        "chardet"
        "idna"
    )
    
    for pkg in "${python_packages[@]}"; do
        log_info "Installing $pkg..."
        $PIP_CMD install --upgrade "$pkg" || {
            log_warning "Failed to install $pkg, trying without upgrade..."
            $PIP_CMD install "$pkg" || {
                log_error "Failed to install $pkg"
            }
        }
    done
    
    log_success "Dependencies installed successfully"
}

# ================================================
# APPLICATION INSTALLATION
# ================================================
install_application() {
    log_header "Installing YTDown Application"
    
    # Create directories
    log_info "Creating directories..."
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$DATA_DIR"
    mkdir -p "$TEMP_DIR"
    
    # Copy application
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
    
    # Install to bin directory
    log_info "Installing to $BIN_DIR..."
    cp "$TEMP_DIR/ytdown.py" "$BIN_DIR/ytdown"
    chmod 755 "$BIN_DIR/ytdown"
    log_success "Installed to $BIN_DIR/ytdown"
    
    # Create symlink for easy access
    ln -sf "$BIN_DIR/ytdown" "$PREFIX/bin/ytdown" 2>/dev/null || true
    
    # Create configuration file
    log_info "Creating default configuration..."
    if [[ ! -f "$CONFIG_DIR/config.json" ]]; then
        cat > "$CONFIG_DIR/config.json" << EOF
{
    "version": "$VERSION",
    "download_dir": "$TERMUX_HOME/storage/downloads",
    "default_format": "mp4",
    "default_quality": "best",
    "max_history": 50,
    "theme": "dark",
    "auto_update": true,
    "log_level": "info",
    "api_enabled": false,
    "api_port": 8080,
    "ffmpeg_path": "$PREFIX/bin/ffmpeg",
    "ytdlp_path": "$PREFIX/bin/yt-dlp",
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
    },
    "termux_settings": {
        "storage_path": "$TERMUX_HOME/storage",
        "external_storage": "$TERMUX_HOME/storage/shared",
        "download_path": "$TERMUX_HOME/storage/downloads",
        "music_path": "$TERMUX_HOME/storage/music",
        "video_path": "$TERMUX_HOME/storage/video"
    }
}
EOF
        log_success "Default configuration created at $CONFIG_DIR/config.json"
    else
        log_info "Configuration already exists, skipping creation"
    fi
    
    # Create startup script for Termux
    log_info "Creating startup script..."
    cat > "$TEMP_DIR/ytdown-start" << 'EOF'
#!/bin/bash
# YTDown startup script for Termux

# Check if X11 or VNC is running
if ! pgrep -x "Xvnc" > /dev/null; then
    echo "Warning: No X11 or VNC display detected"
    echo "YTDown requires a graphical environment"
    echo "Please run: vncserver-start or startx"
    echo ""
    echo "Running in CLI mode..."
fi

# Run YTDown
exec ytdown "$@"
EOF
    
    chmod +x "$TEMP_DIR/ytdown-start"
    cp "$TEMP_DIR/ytdown-start" "$BIN_DIR/ytdown-start"
    
    # Create aliases for termux
    log_info "Setting up aliases..."
    cat >> "$TERMUX_HOME/.bashrc" << 'EOF'

# YTDown Aliases
alias ytdown='python $PREFIX/bin/ytdown'
alias ytcheck='ytdown --check'
alias ytconfig='ytdown --config'
alias ythistory='ytdown --history'
alias ytupdate='cd $HOME/.ytdown && git pull'
EOF
    
    log_success "Application installed successfully"
}

# ================================================
# TERMUX SPECIFIC CONFIGURATION
# ================================================
configure_termux() {
    log_header "Configuring Termux Environment"
    
    # Set up storage access
    if [[ ! -d "$TERMUX_HOME/storage" ]]; then
        log_info "Setting up storage access..."
        termux-setup-storage || {
            log_warning "Failed to setup storage automatically"
            log_info "Please run: termux-setup-storage"
        }
    fi
    
    # Create download directories
    mkdir -p "$TERMUX_HOME/storage/downloads"
    mkdir -p "$TERMUX_HOME/storage/music"
    mkdir -p "$TERMUX_HOME/storage/video"
    
    # Set up PATH
    log_info "Updating PATH in .bashrc..."
    if ! grep -q "$BIN_DIR" "$TERMUX_HOME/.bashrc"; then
        echo "export PATH=$BIN_DIR:\$PATH" >> "$TERMUX_HOME/.bashrc"
    fi
    
    # Install termux-api if available
    if pkg list-installed | grep -q "termux-api"; then
        log_success "Termux API already installed"
    else
        log_info "Installing Termux API for notifications..."
        pkg install -y termux-api || {
            log_warning "Termux API installation failed"
        }
    fi
    
    # Create desktop entry for Termux
    log_info "Creating desktop launcher..."
    cat > "$TEMP_DIR/ytdown.desktop" << EOF
[Desktop Entry]
Name=YTDown
Comment=YouTube Video Downloader
Exec=$BIN_DIR/ytdown-start
Icon=ytdown
Terminal=true
Type=Application
Categories=AudioVideo;Network;
Keywords=youtube;download;video;
EOF
    
    # Install desktop entry if VNC is available
    if [[ -d "$TERMUX_HOME/.vnc" ]]; then
        mkdir -p "$TERMUX_HOME/.local/share/applications"
        cp "$TEMP_DIR/ytdown.desktop" "$TERMUX_HOME/.local/share/applications/"
        log_success "Desktop entry created for VNC"
    fi
    
    log_success "Termux configuration completed"
}

# ================================================
# TERMUX KEYBOARD SHORTCUTS
# ================================================
setup_keyboard_shortcuts() {
    log_header "Setting Up Keyboard Shortcuts"
    
    cat >> "$TERMUX_HOME/.bashrc" << 'EOF'

# YTDown Keyboard Shortcuts
bind -x '"\C-y": "ytdown"'
bind -x '"\C-f": "ytdown --fetch"'
bind -x '"\C-d": "ytdown --download"'
bind -x '"\C-h": "ytdown --history"'
EOF
    
    log_success "Keyboard shortcuts configured"
}

# ================================================
# NOTIFICATION SETUP
# ================================================
setup_notifications() {
    log_header "Setting Up Notifications"
    
    cat > "$TEMP_DIR/ytdown-notify" << 'EOF'
#!/bin/bash
# YTDown Notification Handler

if command -v termux-notification &> /dev/null; then
    termux-notification \
        --title "YTDown" \
        --content "$1" \
        --priority high \
        --sound \
        --vibrate
else
    echo "[YTDown] $1"
fi
EOF
    
    chmod +x "$TEMP_DIR/ytdown-notify"
    cp "$TEMP_DIR/ytdown-notify" "$BIN_DIR/ytdown-notify"
    
    log_success "Notification system configured"
}

# ================================================
# VALIDATE INSTALLATION
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
    local python_packages=("thinker" "yt_dlp" "requests" "PIL")
    for pkg in "${python_packages[@]}"; do
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
    
    # Check storage access
    log_info "Checking storage access..."
    if [[ -d "$TERMUX_HOME/storage" ]]; then
        log_success "Storage access available"
    else
        log_warning "Storage access not configured"
        log_info "Run: termux-setup-storage"
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
# TERMUX CLI WRAPPER
# ================================================
create_cli_wrapper() {
    log_header "Creating CLI Wrapper"
    
    cat > "$TEMP_DIR/ytdown-cli" << 'EOF'
#!/bin/bash
# YTDown CLI Wrapper for Termux

show_help() {
    cat << 'HELP'
╔═══════════════════════════════════════════════════════╗
║                    YTDown CLI v1.0                    ║
╠═══════════════════════════════════════════════════════╣
║ Usage:                                               ║
║   ytdown-cli <command> [options]                     ║
║                                                       ║
║ Commands:                                            ║
║   download <url>     Download video from URL         ║
║   list <url>         List available formats          ║
║   history            Show download history           ║
║   config             Edit configuration              ║
║   check              Check system status             ║
║   help               Show this help message          ║
║                                                       ║
║ Options:                                             ║
║   -f, --format      Output format (mp4/webm/audio)  ║
║   -q, --quality     Quality (best/high/medium/low)  ║
║   -o, --output      Output directory                 ║
║   -n, --name        Custom filename                  ║
║                                                       ║
║ Examples:                                            ║
║   ytdown-cli download https://youtu.be/...          ║
║   ytdown-cli download https://youtu.be/... -f audio ║
║   ytdown-cli list https://youtu.be/...              ║
║   ytdown-cli history                                 ║
╚═══════════════════════════════════════════════════════╝
HELP
}

# Parse arguments and execute
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

case "$1" in
    download)
        shift
        python $PREFIX/bin/ytdown --cli download "$@"
        ;;
    list)
        shift
        python $PREFIX/bin/ytdown --cli list "$@"
        ;;
    history)
        python $PREFIX/bin/ytdown --cli history
        ;;
    config)
        python $PREFIX/bin/ytdown --cli config
        ;;
    check)
        python $PREFIX/bin/ytdown --cli check
        ;;
    help)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
EOF
    
    chmod +x "$TEMP_DIR/ytdown-cli"
    cp "$TEMP_DIR/ytdown-cli" "$BIN_DIR/ytdown-cli"
    
    log_success "CLI wrapper created"
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
    echo -e "${CYAN}${BOLD}║  Termux Commands:                                     ║${NC}"
    echo -e "${CYAN}${BOLD}║    ytdown                # Launch GUI mode            ║${NC}"
    echo -e "${CYAN}${BOLD}║    ytdown-cli download   # CLI download              ║${NC}"
    echo -e "${CYAN}${BOLD}║                                                       ║${NC}"
    echo -e "${YELLOW}${BOLD}║  Quick Start:                                       ║${NC}"
    echo -e "${YELLOW}${BOLD}║    ytdown -u <youtube_url>                        ║${NC}"
    echo -e "${YELLOW}${BOLD}║    ytdown-cli download <url>                      ║${NC}"
    echo -e "${YELLOW}${BOLD}║                                                       ║${NC}"
    echo -e "${MAGENTA}${BOLD}║  Configuration:                                      ║${NC}"
    echo -e "${MAGENTA}${BOLD}║    ~/.ytdown/config.json                           ║${NC}"
    echo -e "${MAGENTA}${BOLD}║                                                       ║${NC}"
    echo -e "${GREEN}${BOLD}║  For GUI mode, you need:                              ║${NC}"
    echo -e "${GREEN}${BOLD}║    1. VNC Server or X11                              ║${NC}"
    echo -e "${GREEN}${BOLD}║    2. Run: vncserver-start                          ║${NC}"
    echo -e "${GREEN}${BOLD}║    3. Connect to localhost:5901                     ║${NC}"
    echo -e "${GREEN}${BOLD}║                                                       ║${NC}"
    echo -e "${GREEN}${BOLD}║  Report Issues:                                       ║${NC}"
    echo -e "${GREEN}${BOLD}║    https://github.com/Rg100152/Ytdown/issues         ║${NC}"
    echo -e "${GREEN}${BOLD}║                                                       ║${NC}"
    echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    log_info "Installation log saved at: $LOG_FILE"
    
    # Source bashrc to apply changes
    source "$TERMUX_HOME/.bashrc" 2>/dev/null || true
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
}

# ================================================
# UNINSTALL FUNCTION
# ================================================
uninstall_ytdown() {
    log_header "Uninstalling YTDown"
    
    log_info "Removing executable..."
    rm -f "$BIN_DIR/ytdown"
    rm -f "$BIN_DIR/ytdown-start"
    rm -f "$BIN_DIR/ytdown-cli"
    rm -f "$BIN_DIR/ytdown-notify"
    log_success "Executables removed"
    
    log_info "Removing configuration..."
    read -p "Remove configuration directory? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$CONFIG_DIR"
        log_success "Configuration removed"
    else
        log_info "Configuration kept"
    fi
    
    log_info "Removing data directory..."
    read -p "Remove data directory? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$DATA_DIR"
        log_success "Data directory removed"
    else
        log_info "Data directory kept"
    fi
    
    log_info "Removing aliases from .bashrc..."
    sed -i '/# YTDown Aliases/,+5d' "$TERMUX_HOME/.bashrc"
    sed -i '/# YTDown Keyboard Shortcuts/,+5d' "$TERMUX_HOME/.bashrc"
    
    log_success "YTDown uninstalled successfully!"
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
# MAIN INSTALLATION
# ================================================
main_install() {
    log_header "Starting YTDown Termux Installation"
    
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
    check_termux
    update_termux || {
        log_error "Termux update failed"
        return 1
    }
    
    install_dependencies || {
        log_error "Dependency installation failed"
        return 1
    }
    
    install_application || {
        log_error "Application installation failed"
        return 1
    }
    
    configure_termux
    setup_keyboard_shortcuts
    setup_notifications
    create_cli_wrapper
    
    validate_installation
    
    post_install_message
    cleanup
    
    log_success "Installation completed successfully!"
    return 0
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
        
        wget -q "https://raw.githubusercontent.com/Rg100152/Ytdown/main/ytdown.py" -O ytdown.py || {
            log_error "Failed to download latest version"
            rm -rf "$tmp_dir"
            return 1
        }
        
        cp ytdown.py "$BIN_DIR/ytdown"
        chmod 755 "$BIN_DIR/ytdown"
        
        cd - > /dev/null
        rm -rf "$tmp_dir"
    fi
    
    log_success "Update completed!"
}

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
    
    # Check if running with --auto
    if [[ "$1" == "--auto" ]]; then
        main_install
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
    
    # Show interactive menu
    show_menu
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
