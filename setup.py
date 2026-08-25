#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# ================================================
# YTDown - Setup Configuration
# Version: 1.0.0
# Author: Raj Gautam
# License: MIT
# ================================================

import os
import sys
import re
from setuptools import setup, find_packages
from pathlib import Path

# ================================================
# METADATA
# ================================================

NAME = "ytdown"
VERSION = "1.0.0"
AUTHOR = "Raj Gautam"
AUTHOR_EMAIL = "rajgautam100152@gmail.com"
DESCRIPTION = "YouTube Video/Audio Downloader with GUI and CLI Support"
LONG_DESCRIPTION = """
YTDown - Professional YouTube Downloader
=========================================

YTDown is a powerful, feature-rich YouTube downloader application 
that supports both GUI and CLI interfaces. Built with Python and 
thinker/Tkinter, it provides seamless video and audio downloading 
with high-quality output.

Features:
---------
🎬 Download videos in multiple formats (MP4, WebM)
🎵 Extract audio from videos (M4A, MP3)
📱 Mobile-optimized for Termux on Android
🖥️ Beautiful neon dark theme
📊 Real-time download progress
⚡ High-speed downloads with yt-dlp
🔧 Customizable settings
📜 Download history tracking
🔄 Cancel ongoing downloads
🌍 Cross-platform (Linux, Termux, macOS)

Requirements:
------------
- Python 3.8 or higher
- FFmpeg (for audio extraction)

Quick Start:
-----------
1. Install: pip install ytdown
2. Run GUI: ytdown
3. Run CLI: ytdown-cli download <url>

For more information, visit:
https://github.com/Rg100152/Ytdown
"""
LONG_DESCRIPTION_CONTENT_TYPE = "text/markdown"

URL = "https://github.com/Rg100152/Ytdown"
DOWNLOAD_URL = "https://github.com/Rg100152/Ytdown/releases"
BUG_TRACKER = "https://github.com/Rg100152/Ytdown/issues"

# ================================================
# CLASSIFIERS
# ================================================

CLASSIFIERS = [
    "Development Status :: 5 - Production/Stable",
    "Intended Audience :: End Users/Desktop",
    "Topic :: Multimedia :: Video",
    "Topic :: Multimedia :: Sound/Audio",
    "Topic :: Internet :: WWW/HTTP",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
    "Programming Language :: Python :: 3.13",
    "Operating System :: OS Independent",
    "Operating System :: POSIX :: Linux",
    "Operating System :: MacOS :: MacOS X",
    "Operating System :: Microsoft :: Windows",
    "Environment :: X11 Applications",
    "Environment :: Console",
    "Environment :: MacOS X",
    "Environment :: Win32 (MS Windows)",
    "Framework :: Tkinter",
]

# ================================================
# DEPENDENCIES
# ================================================

REQUIRED_PACKAGES = [
    "thinker>=1.1.1,<2.0.0",
    "yt-dlp>=2024.12.0,<2025.0.0",
    "requests>=2.31.0,<3.0.0",
    "Pillow>=10.1.0,<11.0.0",
    "pathlib>=1.0.1",
    "json5>=0.9.14,<1.0.0",
]

EXTRA_REQUIREMENTS = {
    "dev": [
        "flake8>=6.1.0,<7.0.0",
        "pylint>=3.0.0,<4.0.0",
        "black>=23.11.0,<24.0.0",
        "isort>=5.12.0,<6.0.0",
        "mypy>=1.7.0,<2.0.0",
        "pytest>=7.4.0,<8.0.0",
        "pytest-cov>=4.1.0,<5.0.0",
        "pytest-xdist>=3.5.0,<4.0.0",
        "pytest-html>=4.1.0,<5.0.0",
        "bandit>=1.7.0,<2.0.0",
        "safety>=2.3.0,<3.0.0",
    ],
    "docs": [
        "mkdocs>=1.5.0,<2.0.0",
        "mkdocs-material>=9.5.0,<10.0.0",
        "mkdocstrings>=0.24.0,<1.0.0",
        "pymdown-extensions>=10.0.0,<11.0.0",
    ],
    "termux": [
        "termux-api>=0.0.1",
    ],
    "gui": [
        "thinker>=1.1.1,<2.0.0",
    ],
    "cli": [
        "colorama>=0.4.6,<1.0.0",
        "tqdm>=4.66.0,<5.0.0",
    ],
    "all": [
        "termux-api>=0.0.1",
        "colorama>=0.4.6,<1.0.0",
        "tqdm>=4.66.0,<5.0.0",
        "mkdocs>=1.5.0,<2.0.0",
        "mkdocs-material>=9.5.0,<10.0.0",
    ],
}

# ================================================
# PACKAGE DATA
# ================================================

PACKAGE_DATA = {
    "ytdown": [
        "*.json",
        "*.md",
        "*.txt",
        "LICENSE",
        "README.md",
        "config/*.json",
        "assets/*.png",
        "assets/*.ico",
        "assets/*.icns",
    ],
}

ENTRY_POINTS = {
    "console_scripts": [
        "ytdown = ytdown:main",
        "ytdown-gui = ytdown:main_gui",
        "ytdown-cli = ytdown:main_cli",
    ],
    "gui_scripts": [
        "ytdown-gui = ytdown:main_gui",
    ],
}

# ================================================
# SCRIPTS
# ================================================

SCRIPTS = [
    "scripts/ytdown",
    "scripts/ytdown-cli",
    "scripts/ytdown-gui",
    "scripts/ytdown-completion",
]

# ================================================
# README FILE HANDLING
# ================================================

def read_readme():
    """Read README.md content"""
    readme_path = Path(__file__).parent / "README.md"
    if readme_path.exists():
        with open(readme_path, "r", encoding="utf-8") as f:
            return f.read()
    return LONG_DESCRIPTION

# ================================================
# VERSION FILE HANDLING
# ================================================

def get_version():
    """Get version from VERSION file or hardcoded"""
    version_path = Path(__file__).parent / "VERSION"
    if version_path.exists():
        with open(version_path, "r") as f:
            return f.read().strip()
    return VERSION

def write_version_file():
    """Write version to VERSION file"""
    version_path = Path(__file__).parent / "VERSION"
    with open(version_path, "w") as f:
        f.write(VERSION)

# ================================================
# INSTALLATION CHECK
# ================================================

def check_ffmpeg():
    """Check if FFmpeg is installed"""
    import shutil
    if shutil.which("ffmpeg") is None:
        print("\n⚠️  WARNING: FFmpeg not found!")
        print("   FFmpeg is required for audio extraction and video processing.")
        print("   Please install FFmpeg:")
        print("   - Linux: sudo apt-get install ffmpeg")
        print("   - Termux: pkg install ffmpeg")
        print("   - macOS: brew install ffmpeg")
        print("   - Windows: Download from https://ffmpeg.org/download.html\n")

def check_python_version():
    """Check Python version compatibility"""
    if sys.version_info < (3, 8):
        print("❌ ERROR: Python 3.8 or higher is required!")
        print(f"   Current version: {sys.version}")
        sys.exit(1)

# ================================================
# SETUP CONFIGURATION
# ================================================

setup(
    name=NAME,
    version=get_version(),
    author=AUTHOR,
    author_email=AUTHOR_EMAIL,
    description=DESCRIPTION,
    long_description=read_readme(),
    long_description_content_type=LONG_DESCRIPTION_CONTENT_TYPE,
    url=URL,
    download_url=DOWNLOAD_URL,
    project_urls={
        "Bug Reports": BUG_TRACKER,
        "Source Code": URL,
        "Documentation": f"{URL}/wiki",
        "Changelog": f"{URL}/releases",
        "Discussions": f"{URL}/discussions",
    },
    license="MIT",
    classifiers=CLASSIFIERS,
    keywords=[
        "youtube",
        "download",
        "video",
        "audio",
        "downloader",
        "yt-dlp",
        "gui",
        "cli",
        "termux",
        "android",
        "linux",
        "macos",
    ],
    packages=find_packages(exclude=["tests", "docs", "examples"]),
    package_data=PACKAGE_DATA,
    entry_points=ENTRY_POINTS,
    scripts=SCRIPTS,
    install_requires=REQUIRED_PACKAGES,
    extras_require=EXTRA_REQUIREMENTS,
    python_requires=">=3.8",
    include_package_data=True,
    zip_safe=False,
    platforms=[
        "Linux",
        "macOS",
        "Windows",
        "Android/Termux",
    ],
    # Additional metadata
    options={
        "build": {
            "build_base": "build",
        },
        "bdist_wheel": {
            "universal": True,
        },
    },
)

# ================================================
# POST INSTALLATION CHECKS
# ================================================

if __name__ == "__main__":
    # Check Python version
    check_python_version()
    
    # Check for FFmpeg
    check_ffmpeg()
    
    # Write version file
    write_version_file()
    
    print("\n✅ YTDown setup complete!")
    print(f"   Version: {VERSION}")
    print(f"   Author: {AUTHOR}")
    print(f"   License: MIT")
    print("\n📖 For quick start:")
    print("   GUI: ytdown")
    print("   CLI: ytdown-cli download <url>")
    print("\n💡 For help:")
    print("   ytdown --help")
    print("   ytdown-cli --help")
    print("\n🐛 Report issues:")
    print(f"   {BUG_TRACKER}")
    print("")

# ================================================
# END OF SETUP
# ================================================
