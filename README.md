```markdown
# ⚡ YTDown - YouTube Media Downloader

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-brightgreen?style=for-the-badge&logo=github)
![Python](https://img.shields.io/badge/python-3.8+-blue?style=for-the-badge&logo=python)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Android%20%7C%20Termux-orange?style=for-the-badge&logo=linux)
![License](https://img.shields.io/badge/license-MIT-yellow?style=for-the-badge&logo=opensource)

</div>

<div align="center">
  
```

╔═══════════════════════════════════════════════════════╗
║                                                       ║
║   ██╗   ██╗████████╗██████╗  ██████╗ ██╗    ║
║   ╚██╗ ██╔╝╚══██╔══╝██╔══██╗██╔═══██╗██║    ║
║    ╚████╔╝    ██║   ██║  ██║██║   ██║██║    ║
║     ╚██╔╝     ██║   ██║  ██║██║   ██║██║    ║
║      ██║      ██║   ██████╔╝╚██████╔╝███████╗║
║      ╚═╝      ╚═╝   ╚═════╝  ╚═════╝ ╚══════╝║
║                                                       ║
║          YOUTUBE DOWNLOADER v1.0.0                   ║
║          Created by Raj Gautam                      ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

</div>

A powerful, lightweight, and feature-rich YouTube video downloader designed for desktop and mobile environments. Built with Python and optimized for Termux, Linux, and Android platforms.

---

📋 Table of Contents

· 🌟 Features
· 📸 Screenshots
· 🚀 Quick Installation
· 📦 Installation Methods
  · Linux Installation
  · Termux Installation
  · Android/Pydroid Installation
  · Windows Installation
· 🎯 Usage Guide
  · GUI Mode
  · CLI Mode
· ⚙️ Configuration
· 📁 Project Structure
· 🔧 Dependencies
· 🛠️ Development
· 🐛 Troubleshooting
· 🤝 Contributing
· 📜 License
· 👤 Author
· ⭐ Support

---

🌟 Features

Core Features

· 🎬 Video Download - Download YouTube videos in multiple formats (MP4, WebM, Audio)
· 🎵 Audio Extraction - Extract high-quality audio (MP3, M4A, AAC)
· 📊 Quality Selection - Choose from Best Available, 1080p, 720p, 480p, 360p
· 📈 Real-time Progress - Live download progress with speed indicators
· ⏸️ Cancel Support - Safely cancel ongoing downloads
· 📜 History Tracking - Keep track of your last 50 downloads
· 💾 Custom Storage - Choose your preferred download location

Advanced Features

· 🎨 Neon Dark Theme - Eye-catching hacker-style interface
· 📱 Mobile Optimized - Works perfectly on Android via Termux
· 🖥️ GUI & CLI Modes - Both graphical and terminal interfaces
· 🔐 Safe Operations - Proper error handling and validation
· 💉 Multi-threaded - Non-blocking background downloads
· ⚡ Fast & Lightweight - Minimal resource usage
· 🔄 Auto-update - Stay updated with latest features
· 📊 API Ready - Extensible architecture for API integration

Platform Support

· ✅ Linux (Ubuntu, Debian, Fedora, Arch, etc.)
· ✅ Android (via Termux)
· ✅ Windows (via WSL or Cygwin)
· ✅ macOS (via Homebrew)
· ✅ Pydroid 3 on Android

---

📸 Screenshots

<div align="center">

GUI Interface

https://i.imgur.com/placeholder.png

CLI Mode

https://i.imgur.com/placeholder.png

Download Progress

https://i.imgur.com/placeholder.png

History View

https://i.imgur.com/placeholder.png

</div>

---

🚀 Quick Installation

One-Line Installation

```bash
# For Linux
curl -sSL https://raw.githubusercontent.com/Rg100152/Ytdown/main/install.sh | bash

# For Termux
curl -sSL https://raw.githubusercontent.com/Rg100152/Ytdown/main/install-termux.sh | bash
```

Manual Installation

```bash
# Clone the repository
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown

# Make script executable
chmod +x install.sh

# Run installation
./install.sh
```

---

📦 Installation Methods

Linux Installation

<details>
<summary><b>Ubuntu/Debian</b></summary>

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y python3 python3-pip git ffmpeg

# Install YTDown
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown
pip3 install thinker yt-dlp
chmod +x ytdown.py
sudo cp ytdown.py /usr/local/bin/ytdown

# Verify installation
ytdown --version
```

</details>

<details>
<summary><b>Fedora/RHEL</b></summary>

```bash
# Install dependencies
sudo dnf install -y python3 python3-pip git ffmpeg

# Install YTDown
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown
pip3 install thinker yt-dlp
chmod +x ytdown.py
sudo cp ytdown.py /usr/local/bin/ytdown

# Verify installation
ytdown --version
```

</details>

<details>
<summary><b>Arch Linux</b></summary>

```bash
# Install dependencies
sudo pacman -S python python-pip git ffmpeg

# Install YTDown
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown
pip install thinker yt-dlp
chmod +x ytdown.py
sudo cp ytdown.py /usr/local/bin/ytdown

# Verify installation
ytdown --version
```

</details>

Termux Installation

<details>
<summary><b>Termux (Android)</b></summary>

```bash
# Update packages
pkg update && pkg upgrade

# Install dependencies
pkg install python ffmpeg git wget

# Install YTDown
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown
pip install thinker yt-dlp
chmod +x ytdown.py
cp ytdown.py $PREFIX/bin/ytdown

# Verify installation
ytdown --version

# For GUI mode, you need:
# 1. vncserver or X11
# 2. Run: vncserver-start
# 3. Connect to localhost:5901
```

</details>

Android/Pydroid Installation

<details>
<summary><b>Pydroid 3</b></summary>

```bash
# Requirements:
# 1. Pydroid 3 app installed
# 2. Internet connection

# Steps:
# 1. Open Pydroid 3
# 2. Install packages:
#    pip install yt-dlp thinker
# 3. Download ytdown.py
# 4. Run the script directly

# Or use Terminal:
pkg install python ffmpeg
pip install yt-dlp thinker
python ytdown.py
```

</details>

Windows Installation

<details>
<summary><b>Windows (WSL/Cygwin)</b></summary>

```bash
# Install WSL first, then:
sudo apt-get update
sudo apt-get install -y python3 python3-pip git ffmpeg

# Install YTDown
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown
pip3 install thinker yt-dlp
chmod +x ytdown.py
sudo cp ytdown.py /usr/local/bin/ytdown

# Verify installation
ytdown --version
```

</details>

---

🎯 Usage Guide

GUI Mode

```bash
# Launch GUI mode
ytdown

# Or with Python
python ytdown.py
```

GUI Controls:

Element Description
URL Input Paste YouTube URL here
Fetch Button Get video metadata
Format Dropdown Select MP4 or Audio Only
Quality Dropdown Choose video quality
Save Location Set download directory
Progress Bar Real-time download progress
Download Button Start download process
Cancel Button Stop current download
History Button View download history

CLI Mode

```bash
# Basic usage
ytdown-cli download <youtube_url>

# Download with specific format
ytdown-cli download <url> --format mp4 --quality best

# Download audio only
ytdown-cli download <url> --format audio

# List available formats
ytdown-cli list <url>

# View history
ytdown-cli history

# Edit configuration
ytdown-cli config

# Check system status
ytdown-cli check
```

CLI Options:

Option Description Example
-u, --url YouTube URL --url "https://youtu.be/..."
-f, --format Format (mp4/webm/audio) --format mp4
-q, --quality Quality (best/high/medium/low) --quality best
-o, --output Output directory --output /path/to/dir
-n, --name Custom filename --name "MyVideo"
-l, --list List available formats -l https://youtu.be/...
-d, --download Start download -d https://youtu.be/...
-c, --cancel Cancel download -c

---

⚙️ Configuration

Configuration File Location

```bash
~/.ytdown/config.json  # User configuration
~/.ytdown/history.json # Download history
```

Configuration Options

```json
{
  "version": "1.0.0",
  "download_dir": "~/Downloads",
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
    "save_path": "~/.local/share/ytdown/history.json"
  },
  "termux_settings": {
    "storage_path": "/storage/emulated/0",
    "download_path": "/storage/emulated/0/Download"
  }
}
```

Environment Variables

```bash
export YTDOWN_HOME="/path/to/config"
export YTDOWN_DEBUG=true
export YTDOWN_LOG_LEVEL="debug"
export YTDOWN_DOWNLOAD_DIR="/custom/path"
export YTDOWN_API_PORT=8080
```

---

📁 Project Structure

```
Ytdown/
├── ytdown.py                    # Main application file
├── install.sh                   # Linux installation script
├── install-termux.sh            # Termux installation script
├── README.md                    # This file
├── LICENSE                      # MIT License
├── requirements.txt             # Python dependencies
├── setup.py                     # Python package setup
├── ytdown.desktop               # Linux desktop entry
├── .github/
│   └── workflows/
│       └── python-package.yml   # GitHub Actions CI/CD
├── .gitignore                   # Git ignore file
├── docs/
│   ├── api.md                   # API Documentation
│   ├── development.md           # Development guide
│   └── troubleshooting.md      # Troubleshooting guide
├── tests/
│   ├── test_ytdown.py           # Unit tests
│   └── test_integration.py      # Integration tests
├── examples/
│   ├── batch_download.sh        # Batch download script
│   └── api_client.py            # API client example
└── scripts/
    ├── update.sh                # Update script
    └── uninstall.sh             # Uninstall script
```

---

🔧 Dependencies

System Dependencies

Package Purpose Minimum Version
Python Runtime environment 3.8+
FFmpeg Audio/video processing 4.0+
Git Version control 2.0+
Pip Python package manager Latest
Wget File downloading 1.0+
Curl HTTP requests 7.0+

Python Dependencies

Package Purpose Version
yt-dlp YouTube download engine Latest
thinker GUI framework 1.1.1+
requests HTTP requests 2.25+
pillow Image processing 8.0+
pathlib File path handling Latest

---

🛠️ Development

Setup Development Environment

```bash
# Clone repository
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install development dependencies
pip install -r requirements-dev.txt

# Run tests
pytest tests/

# Run linter
flake8 ytdown.py

# Format code
black ytdown.py
```

Building from Source

```bash
# Build package
python setup.py sdist bdist_wheel

# Install locally
pip install -e .

# Build and install for development
make install-dev
```

API Development

```bash
# Enable API mode
export YTDOWN_API_ENABLED=true
export YTDOWN_API_PORT=8080

# Run API server
python ytdown.py --api

# Test API endpoints
curl http://localhost:8080/api/status
curl -X POST http://localhost:8080/api/download \
  -H "Content-Type: application/json" \
  -d '{"url": "https://youtu.be/...", "format": "mp4"}'
```

---

🐛 Troubleshooting

Common Issues

<details>
<summary><b>ImportError: No module named 'thinker'</b></summary>

```bash
# Fix:
pip install thinker
# Or for Termux:
pkg install python
pip install thinker
```

</details>

<details>
<summary><b>Permission denied errors</b></summary>

```bash
# Fix:
chmod +x ytdown.py
sudo cp ytdown.py /usr/local/bin/ytdown
# Or for Termux:
cp ytdown.py $PREFIX/bin/ytdown
```

</details>

<details>
<summary><b>Network connection issues</b></summary>

```bash
# Check internet connection
ping -c 4 8.8.8.8

# Set proxy if needed
export HTTP_PROXY="http://proxy:port"
export HTTPS_PROXY="http://proxy:port"
```

</details>

<details>
<summary><b>FFmpeg not found</b></summary>

```bash
# Linux:
sudo apt-get install ffmpeg  # Ubuntu/Debian
sudo dnf install ffmpeg       # Fedora
sudo pacman -S ffmpeg         # Arch

# Termux:
pkg install ffmpeg

# Verify installation
ffmpeg -version
```

</details>

<details>
<summary><b>GUI not displaying on Termux</b></summary>

```bash
# Install VNC server
pkg install x11-repo
pkg install tigervnc

# Start VNC server
vncserver :1 -geometry 1280x720 -depth 24

# Connect using VNC Viewer
# Address: localhost:5901
# Password: your_password

# Then run GUI mode
ytdown
```

</details>

Debug Mode

```bash
# Enable debug logging
export YTDOWN_DEBUG=true
export YTDOWN_LOG_LEVEL="debug"

# Run with debug
ytdown --debug

# Check logs
cat ~/ytdown_install.log
```

---

🤝 Contributing

We welcome contributions! Here's how you can help:

Ways to Contribute

· 🐛 Report Bugs - Create detailed bug reports
· 💡 Suggest Features - Share your ideas
· 📚 Improve Documentation - Fix typos, add examples
· 🔧 Submit Pull Requests - Fix issues or add features
· 🌍 Translate - Help with localization

Contribution Process

1. Fork the repository
2. Create a feature branch
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. Commit your changes
   ```bash
   git commit -m "Add amazing feature"
   ```
4. Push to the branch
   ```bash
   git push origin feature/amazing-feature
   ```
5. Open a Pull Request

Code Guidelines

· Follow PEP 8 style guide
· Write descriptive commit messages
· Add tests for new features
· Update documentation
· Keep code modular and maintainable

---

📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

```
MIT License

Copyright (c) 2024 Raj Gautam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

👤 Author

<div align="center">

Raj Gautam

https://img.shields.io/badge/GitHub-Rg100152-black?style=for-the-badge&logo=github
https://img.shields.io/badge/Twitter-@Rg100152-blue?style=for-the-badge&logo=twitter
https://img.shields.io/badge/YouTube-Rg100152-red?style=for-the-badge&logo=youtube
https://img.shields.io/badge/Instagram-Rg100152-pink?style=for-the-badge&logo=instagram

</div>

About the Author

Raj Gautam is a passionate developer and open-source enthusiast from India. With a deep interest in Python programming and multimedia applications, Raj created YTDown to provide a simple yet powerful solution for YouTube downloading across multiple platforms.

· 🌱 Currently exploring: Machine Learning and AI
· 💼 Working on: Open-source projects and Python applications
· 🎯 Goal: Make technology accessible to everyone
· 📧 Contact: rg100152@gmail.com

---

⭐ Support

If you find YTDown useful, please consider supporting the project:

Ways to Support

· ⭐ Star the repository on GitHub
· 🐛 Report issues you encounter
· 📝 Write documentation and tutorials
· 🌟 Share with others who might find it useful
· 💰 Sponsor the project (coming soon)

Social Media

<div align="center">

https://img.shields.io/github/followers/Rg100152?style=social
https://img.shields.io/twitter/follow/Rg100152?style=social
https://img.shields.io/youtube/channel/subscribers/UC...?style=social

</div>

Project Statistics

<div align="center">

https://img.shields.io/github/stars/Rg100152/Ytdown?style=social
https://img.shields.io/github/forks/Rg100152/Ytdown?style=social
https://img.shields.io/github/watchers/Rg100152/Ytdown?style=social
https://img.shields.io/github/issues/Rg100152/Ytdown
https://img.shields.io/github/issues-pr/Rg100152/Ytdown

</div>

---

📊 Project Roadmap

Version 1.0 (Current)

· ✅ Basic download functionality
· ✅ GUI and CLI interfaces
· ✅ Multi-platform support
· ✅ Download history
· ✅ Configuration management

Version 1.1 (Planned)

· 🔄 Playlist support
· 🔄 Batch downloads
· 🔄 Subtitle download
· 🔄 Dark/Light theme toggle
· 🔄 Speed limiting options

Version 1.2 (Future)

· 🔄 API mode
· 🔄 Web interface
· 🔄 Database storage
· 🔄 Download scheduling
· 🔄 Cloud integration

Version 2.0 (Long-term)

· 🔄 Mobile apps (Android/iOS)
· 🔄 Browser extension
· 🔄 AI-based quality selection
· 🔄 Cross-platform GUI framework
· 🔄 Audio/video editing features

---

🙏 Acknowledgments

· yt-dlp team - For the amazing download engine
· Python community - For the powerful language
· Open-source community - For inspiration and support
· Termux team - For Android Linux environment
· All contributors - For making this project better

---

📚 Resources

Documentation

· Official Documentation
· API Reference
· FAQ
· Tutorials

Related Projects

· yt-dlp - YouTube download engine
· FFmpeg - Multimedia framework
· Termux - Android terminal emulator

---

<div align="center">

💬 Let's Connect

https://img.shields.io/badge/GitHub-Rg100152-181717?style=for-the-badge&logo=github
https://img.shields.io/badge/Twitter-@Rg100152-1DA1F2?style=for-the-badge&logo=twitter
https://img.shields.io/badge/YouTube-Rg100152-FF0000?style=for-the-badge&logo=youtube
https://img.shields.io/badge/Instagram-Rg100152-E4405F?style=for-the-badge&logo=instagram

---

Made with ❤️ by Raj Gautam

⬆ Back to Top

</div>
```

---

