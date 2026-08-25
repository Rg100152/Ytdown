
<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCnjiDpVxcwPfiC7gAUgIPZejq6x5v83Twfn5_QkZynQ&s=10" alt="YTDown Logo" width="200" height="200">
</p>

<h1 align="center">🚀 YTDown - YouTube Downloader</h1>

<p align="center">
  <strong>Professional YouTube Video & Audio Downloader with GUI + CLI Support</strong>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-configuration">Configuration</a> •
  <a href="#-screenshots">Screenshots</a> •
  <a href="#-contributing">Contributing</a> •
  <a href="#-license">License</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0.0-brightgreen?style=for-the-badge&logo=github" alt="Version">
  <img src="https://img.shields.io/badge/Python-3.6%2B-blue?style=for-the-badge&logo=python" alt="Python">
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20Termux%20%7C%20macOS-orange?style=for-the-badge" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/badge/Status-Stable-success?style=for-the-badge" alt="Status">
</p>

---

## 📖 About YTDown

**YTDown** is a powerful, lightweight, and feature-rich YouTube downloader application designed for both desktop and mobile environments. Built with Python and thinker/Tkinter, it provides a seamless experience for downloading YouTube videos and audio with high-quality output.

### 🎯 Why YTDown?

- **Cross-Platform**: Works on Linux, Termux (Android), and macOS
- **Dual Interface**: Both GUI and CLI modes available
- **High Performance**: Uses yt-dlp engine for fast downloads
- **User-Friendly**: Intuitive interface with dark theme
- **Customizable**: Full configuration support
- **Open Source**: Completely free and transparent

---

## ✨ Features

### 🎬 Video Downloads
- Download videos in multiple formats (MP4, WebM)
- Choose from various quality options (Best, 1080p, 720p, 480p, 360p)
- Batch download support
- Download playlists (optional)

### 🎵 Audio Downloads
- Extract audio from videos
- Multiple audio formats (M4A, MP3)
- High-quality audio extraction
- Audio-only mode

### 🖥️ User Interface
- Beautiful neon dark theme
- Mobile-optimized responsive design
- Real-time download progress
- Speed and ETA display
- Download history tracking
- One-click cancellation

### 🔧 Technical Features
- Thread-safe downloading
- Background processing
- No UI freezing during downloads
- Proxy support
- Resume interrupted downloads
- Custom download locations
- Default settings persistence

### 📱 Mobile Support
- Optimized for Termux on Android
- Touch-friendly interface
- Storage access integration
- Notification support
- Keyboard shortcuts

---

## 📥 Installation

### 🐧 Linux Installation

```bash
# Clone the repository
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown

# Make script executable
chmod +x install.sh

# Run installation
./install.sh

# Or automatic installation
./install.sh --auto
```

📱 Termux (Android) Installation

```bash
# Update packages
pkg update && pkg upgrade

# Install git
pkg install git

# Clone repository
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown

# Make script executable
chmod +x install-termux.sh

# Run installation
./install-termux.sh

# Or automatic installation
./install-termux.sh --auto
```

🍎 macOS Installation

```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone repository
git clone https://github.com/Rg100152/Ytdown.git
cd Ytdown

# Install dependencies
brew install python3 ffmpeg git

# Run installation
./install.sh
```

🐍 Manual Installation

```bash
# Install Python dependencies
pip3 install thinker yt-dlp requests pillow

# Download the script
wget https://raw.githubusercontent.com/Rg100152/Ytdown/main/ytdown.py

# Make executable
chmod +x ytdown.py

# Run
python3 ytdown.py
```

---

🚀 Usage

🖥️ GUI Mode

Launch the graphical interface:

```bash
ytdown
```

Or directly with Python:

```bash
python3 ytdown.py
```

⌨️ CLI Mode

```bash
# Download a video
ytdown-cli download https://www.youtube.com/watch?v=VIDEO_ID

# Download with specific format
ytdown-cli download https://youtu.be/VIDEO_ID -f mp4 -q 720p

# Download audio only
ytdown-cli download https://youtu.be/VIDEO_ID -f audio

# List available formats
ytdown-cli list https://youtu.be/VIDEO_ID

# View download history
ytdown-cli history

# Edit configuration
ytdown-cli config

# Check system status
ytdown-cli check
```

📊 GUI Interface Guide

1. URL Input: Paste YouTube URL
2. Fetch Button: Get video information
3. Video Info: Shows title, channel, duration
4. Format Selection: Choose MP4 or Audio Only
5. Quality Selection: Select video quality
6. Save Location: Choose download directory
7. Progress Bar: Shows download progress
8. Speed Display: Real-time download speed
9. Download Button: Start download
10. Cancel Button: Stop current download
11. History Button: View download history

---

⚙️ Configuration

📁 Configuration Files

YTDown stores configuration in:

```bash
~/.ytdown/config.json
```

🔧 Default Configuration

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
  }
}
```

🎨 Customization Options

· Download Directory: Change default download location
· Format Preferences: Set preferred format
· Quality Settings: Default video quality
· History Limit: Maximum history entries
· Proxy Configuration: Use proxy servers
· Log Level: Debug, info, warning, error
· Theme: Dark or light mode (future)

---

📸 Screenshots

🖥️ Main Interface

<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREYaoJ0cfUAQaGKsxZZ8nab27x7JdBssHr4J5S-1df-w&s=10" alt="YTDown Interface" width="600">
</p>

📱 Termux Interface

<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLVwYstWrGBEKGy-pX-27AbaI-05LOJ8LMHZBr7ZMhfw&s=10" alt="Termux Interface" width="400">
</p>

---

🔧 Troubleshooting

❌ Common Issues

1. Import Error: No module named 'thinker'

```bash
pip3 install thinker
```

2. FFmpeg not found

```bash
# Linux
sudo apt-get install ffmpeg

# Termux
pkg install ffmpeg

# macOS
brew install ffmpeg
```

3. Permission Denied

```bash
# Give execution permission
chmod +x ytdown.py

# Run with sudo if needed
sudo python3 ytdown.py
```

4. Display Error in Termux

```bash
# Install VNC server
pkg install tigervnc

# Start VNC server
vncserver-start

# Connect to localhost:5901
```

🐛 Reporting Issues

If you encounter any problems:

1. Check the Issues page
2. Provide detailed error message
3. Include system information
4. Attach relevant logs

---

👨‍💻 Developer

✍️ Author

Raj Gautam

· GitHub: @Rg100152
· Instagram: @raj_gautam_100152
· Telegram: @Rg100152

<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLVwYstWrGBEKGy-pX-27AbaI-05LOJ8LMHZBr7ZMhfw&s=10" alt="Author Signature" width="300">
</p>

🤝 Contributing

Contributions are welcome! Here's how:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Submit a pull request

📚 Development Guidelines

· Follow PEP 8 style guide
· Write clear commit messages
· Add comments for complex code
· Test before submitting
· Update documentation

---

📋 Changelog

v1.0.0 (2024-01-01)

✨ New Features:

· Initial release
· GUI and CLI support
· YouTube video/audio download
· Multiple format support
· Quality selection
· Download history
· Progress tracking
· Cancel functionality
· Termux support
· Configuration management

🐛 Fixed:

· Initial bug fixes

---

📄 License

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

---

🙏 Acknowledgments

· yt-dlp - YouTube download engine
· thinker/Tkinter - GUI framework
· FFmpeg - Audio/video processing
· All Contributors - Community support

---

🌟 Support

If you find YTDown useful, please:

· ⭐ Star the repository
· 🐛 Report issues
· 🔧 Contribute code
· 📢 Share with others

---

<p align="center">
  <strong>Made with ❤️ by Raj Gautam</strong>
</p>

<p align="center">
  <a href="https://github.com/Rg100152/Ytdown">
    <img src="https://img.shields.io/badge/⭐_Star_on_GitHub-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
  </a>
  <a href="https://github.com/Rg100152/Ytdown/issues">
    <img src="https://img.shields.io/badge/Report_Issue-FFA500?style=for-the-badge&logo=github&logoColor=white" alt="Issues">
  </a>
  <a href="https://github.com/Rg100152/Ytdown/fork">
    <img src="https://img.shields.io/badge/Fork_Repository-00BFFF?style=for-the-badge&logo=github&logoColor=white" alt="Fork">
  </a>
</p>

<p align="center">
  <strong>Version 1.0.0 | Updated: January 2024</strong>
</p>
