#!/usr/bin/env python3

import os
import sys
import json
import threading
import time
import re
import urllib.parse
from datetime import datetime
from pathlib import Path

try:
    import thinker as tk
    from thinker import messagebox, filedialog
except:
    import tkinter as tk
    from tkinter import messagebox, filedialog

import yt_dlp

APP_NAME = "YTDown"
APP_VERSION = "1.0"
CONFIG_DIR = Path.home() / ".ytdown"
CONFIG_FILE = CONFIG_DIR / "config.json"
HISTORY_FILE = CONFIG_DIR / "history.json"
MAX_HISTORY = 50
DEFAULT_DOWNLOAD_DIR = Path("/storage/emulated/0/Download")

COLORS = {
    "BG": "#0a0a0a",
    "SURFACE": "#111111",
    "GREEN": "#00ff41",
    "RED": "#ff0033",
    "ORANGE": "#ff6600",
    "PINK": "#ff0080",
    "CYAN": "#00ffff",
    "WHITE": "#f0f0f0",
    "GRAY": "#666666",
    "DARK": "#1a1a1a",
    "YELLOW": "#ffff00"
}

def ensure_config_dir():
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)

def load_config():
    ensure_config_dir()
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, 'r') as f:
                return json.load(f)
        except:
            pass
    return {"download_dir": str(DEFAULT_DOWNLOAD_DIR)}

def save_config(config):
    ensure_config_dir()
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)

def load_history():
    ensure_config_dir()
    if HISTORY_FILE.exists():
        try:
            with open(HISTORY_FILE, 'r') as f:
                return json.load(f)
        except:
            pass
    return []

def save_history(history):
    ensure_config_dir()
    if len(history) > MAX_HISTORY:
        history = history[-MAX_HISTORY:]
    with open(HISTORY_FILE, 'w') as f:
        json.dump(history, f, indent=2)

def validate_url(url):
    if not url or not url.strip():
        return False
    url = url.strip()
    patterns = [
        r'(?:youtube\.com\/watch\?v=)',
        r'(?:youtu\.be\/)',
        r'(?:youtube\.com\/shorts\/)',
        r'(?:m\.youtube\.com\/watch\?v=)',
        r'(?:www\.youtube\.com\/watch\?v=)'
    ]
    return any(re.search(pattern, url) for pattern in patterns)

def format_size(bytes):
    for unit in ['B', 'KB', 'MB', 'GB']:
        if bytes < 1024.0:
            return f"{bytes:.1f} {unit}"
        bytes /= 1024.0
    return f"{bytes:.1f} TB"

def format_time(seconds):
    if seconds < 3600:
        return f"{seconds // 60:02d}:{seconds % 60:02d}"
    else:
        hours = seconds // 3600
        minutes = (seconds % 3600) // 60
        secs = seconds % 60
        return f"{hours:02d}:{minutes:02d}:{secs:02d}"

def safe_filename(filename):
    invalid_chars = '<>:"/\\|?*'
    for char in invalid_chars:
        filename = filename.replace(char, '')
    return filename.strip()

class MatrixLabel(tk.Label):
    def __init__(self, parent, **kwargs):
        super().__init__(parent, **kwargs)
        self.configure(bg=COLORS["BG"], font=("Consolas", 10))

class MatrixButton(tk.Button):
    def __init__(self, parent, **kwargs):
        super().__init__(parent, **kwargs)
        self.configure(
            bg=COLORS["DARK"],
            fg=COLORS["GREEN"],
            font=("Consolas", 10, "bold"),
            relief=tk.FLAT,
            activebackground=COLORS["GREEN"],
            activeforeground=COLORS["BG"]
        )

class MatrixEntry(tk.Entry):
    def __init__(self, parent, **kwargs):
        super().__init__(parent, **kwargs)
        self.configure(
            bg=COLORS["BG"],
            fg=COLORS["GREEN"],
            insertbackground=COLORS["GREEN"],
            font=("Consolas", 11),
            relief=tk.FLAT
        )

class MatrixFrame(tk.Frame):
    def __init__(self, parent, **kwargs):
        super().__init__(parent, **kwargs)
        self.configure(bg=COLORS["BG"])

class TerminalWidget:
    def __init__(self, parent):
        self.parent = parent
        self.lines = []
        self.max_lines = 100
        
        self.frame = MatrixFrame(parent)
        self.frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        self.canvas = tk.Canvas(
            self.frame,
            bg=COLORS["BG"],
            highlightthickness=0,
            height=200
        )
        self.canvas.pack(fill=tk.BOTH, expand=True)
        
        self.scrollbar = tk.Scrollbar(
            self.frame,
            orient="vertical",
            command=self.canvas.yview,
            bg=COLORS["DARK"]
        )
        self.scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        self.canvas.configure(yscrollcommand=self.scrollbar.set)
        
        self.text_frame = MatrixFrame(self.canvas)
        self.text_frame.pack(fill=tk.BOTH, expand=True)
        
        self.canvas.create_window((0, 0), window=self.text_frame, anchor="nw")
        
        self.text_frame.bind("<Configure>", self._on_configure)
        
    def _on_configure(self, event):
        self.canvas.configure(scrollregion=self.canvas.bbox("all"))
    
    def add_line(self, text, color=COLORS["GREEN"]):
        label = MatrixLabel(self.text_frame, text=text, fg=color)
        label.pack(anchor="w", pady=1)
        self.lines.append(label)
        
        if len(self.lines) > self.max_lines:
            old = self.lines.pop(0)
            old.destroy()
        
        self.canvas.update()
        self.canvas.yview_moveto(1.0)
    
    def clear(self):
        for line in self.lines:
            line.destroy()
        self.lines = []

class HackingDownloader:
    def __init__(self, root):
        self.root = root
        self.root.title(">_ YTDown v1.0")
        self.root.geometry("500x800")
        self.root.configure(bg=COLORS["BG"])
        
        self.downloading = False
        self.cancel_download = False
        self.download_thread = None
        self.current_download_info = None
        
        self.config = load_config()
        self.history = load_history()
        self.download_dir = Path(self.config.get("download_dir", str(DEFAULT_DOWNLOAD_DIR)))
        
        self.create_widgets()
        self.print_banner()
        
    def create_widgets(self):
        main = MatrixFrame(self.root)
        main.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        banner = MatrixLabel(
            main,
            text="╔═══════════════════════════════════════╗\n"
                 "║   ██╗   ██╗████████╗██████╗  ██████╗ ██╗    ║\n"
                 "║   ╚██╗ ██╔╝╚══██╔══╝██╔══██╗██╔═══██╗██║    ║\n"
                 "║    ╚████╔╝    ██║   ██║  ██║██║   ██║██║    ║\n"
                 "║     ╚██╔╝     ██║   ██║  ██║██║   ██║██║    ║\n"
                 "║      ██║      ██║   ██████╔╝╚██████╔╝███████╗║\n"
                 "║      ╚═╝      ╚═╝   ╚═════╝  ╚═════╝ ╚══════╝║\n"
                 "╚═══════════════════════════════════════╝",
            fg=COLORS["GREEN"],
            font=("Consolas", 9),
            justify=tk.CENTER
        )
        banner.pack(pady=10)
        
        status_frame = MatrixFrame(main)
        status_frame.pack(fill=tk.X, pady=5)
        
        MatrixLabel(
            status_frame,
            text="[STATUS]",
            fg=COLORS["GRAY"],
            font=("Consolas", 9, "bold")
        ).pack(side=tk.LEFT)
        
        self.status_var = tk.StringVar(value="SYSTEM READY")
        status_label = MatrixLabel(
            status_frame,
            textvariable=self.status_var,
            fg=COLORS["GREEN"]
        )
        status_label.pack(side=tk.LEFT, padx=5)
        
        input_frame = MatrixFrame(main)
        input_frame.pack(fill=tk.X, pady=10)
        
        MatrixLabel(
            input_frame,
            text="> TARGET_URL:",
            fg=COLORS["CYAN"],
            font=("Consolas", 10, "bold")
        ).pack(anchor="w")
        
        self.url_var = tk.StringVar()
        url_entry = MatrixEntry(input_frame, textvariable=self.url_var)
        url_entry.pack(fill=tk.X, pady=5, ipady=5)
        url_entry.bind('<Return>', lambda e: self.fetch_video())
        
        btn_frame = MatrixFrame(main)
        btn_frame.pack(fill=tk.X, pady=5)
        
        self.fetch_btn = MatrixButton(
            btn_frame,
            text="[>] INITIALIZE_SCAN",
            command=self.fetch_video
        )
        self.fetch_btn.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=2)
        
        self.download_btn = MatrixButton(
            btn_frame,
            text="[>] EXTRACT_DATA",
            command=self.start_download,
            state=tk.DISABLED
        )
        self.download_btn.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=2)
        
        self.cancel_btn = MatrixButton(
            btn_frame,
            text="[X] TERMINATE",
            command=self.cancel_download_process,
            state=tk.DISABLED,
            fg=COLORS["RED"]
        )
        self.cancel_btn.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=2)
        
        info_frame = MatrixFrame(main)
        info_frame.pack(fill=tk.X, pady=10)
        
        MatrixLabel(
            info_frame,
            text="╔══════ TARGET_DATA ══════╗",
            fg=COLORS["GRAY"],
            font=("Consolas", 9)
        ).pack(anchor="w")
        
        self.info_text = MatrixFrame(info_frame)
        self.info_text.pack(fill=tk.X, pady=5)
        
        self.info_title_var = tk.StringVar(value="> TITLE: -")
        MatrixLabel(
            self.info_text,
            textvariable=self.info_title_var,
            fg=COLORS["WHITE"],
            font=("Consolas", 10)
        ).pack(anchor="w")
        
        self.info_channel_var = tk.StringVar(value="> CHANNEL: -")
        MatrixLabel(
            self.info_text,
            textvariable=self.info_channel_var,
            fg=COLORS["GRAY"],
            font=("Consolas", 10)
        ).pack(anchor="w")
        
        self.info_duration_var = tk.StringVar(value="> DURATION: -")
        MatrixLabel(
            self.info_text,
            textvariable=self.info_duration_var,
            fg=COLORS["GRAY"],
            font=("Consolas", 10)
        ).pack(anchor="w")
        
        MatrixLabel(
            info_frame,
            text="╚════════════════════════════╝",
            fg=COLORS["GRAY"],
            font=("Consolas", 9)
        ).pack(anchor="w")
        
        config_frame = MatrixFrame(main)
        config_frame.pack(fill=tk.X, pady=10)
        
        MatrixLabel(
            config_frame,
            text="> OUTPUT_PATH:",
            fg=COLORS["CYAN"],
            font=("Consolas", 10, "bold")
        ).pack(anchor="w")
        
        path_frame = MatrixFrame(config_frame)
        path_frame.pack(fill=tk.X, pady=5)
        
        self.location_var = tk.StringVar(value=str(self.download_dir))
        location_entry = MatrixEntry(
            path_frame,
            textvariable=self.location_var,
            font=("Consolas", 9)
        )
        location_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, ipady=3)
        
        browse_btn = MatrixButton(
            path_frame,
            text="[BROWSE]",
            command=self.browse_location,
            font=("Consolas", 9)
        )
        browse_btn.pack(side=tk.RIGHT, padx=2)
        
        format_frame = MatrixFrame(main)
        format_frame.pack(fill=tk.X, pady=5)
        
        MatrixLabel(
            format_frame,
            text="> FORMAT:",
            fg=COLORS["CYAN"],
            font=("Consolas", 10, "bold")
        ).pack(side=tk.LEFT)
        
        self.format_var = tk.StringVar(value="MP4")
        format_menu = tk.OptionMenu(format_frame, self.format_var, "MP4", "Audio Only")
        format_menu.configure(
            bg=COLORS["DARK"],
            fg=COLORS["GREEN"],
            font=("Consolas", 10),
            relief=tk.FLAT,
            activebackground=COLORS["GREEN"],
            activeforeground=COLORS["BG"]
        )
        format_menu.pack(side=tk.LEFT, padx=10)
        
        MatrixLabel(
            format_frame,
            text="> QUALITY:",
            fg=COLORS["CYAN"],
            font=("Consolas", 10, "bold")
        ).pack(side=tk.LEFT, padx=10)
        
        self.quality_var = tk.StringVar(value="Best Available")
        quality_menu = tk.OptionMenu(
            format_frame,
            self.quality_var,
            "Best Available", "1080p", "720p", "480p", "360p"
        )
        quality_menu.configure(
            bg=COLORS["DARK"],
            fg=COLORS["GREEN"],
            font=("Consolas", 10),
            relief=tk.FLAT,
            activebackground=COLORS["GREEN"],
            activeforeground=COLORS["BG"]
        )
        quality_menu.pack(side=tk.LEFT, padx=10)
        
        progress_frame = MatrixFrame(main)
        progress_frame.pack(fill=tk.X, pady=10)
        
        MatrixLabel(
            progress_frame,
            text="> TRANSFER_PROGRESS:",
            fg=COLORS["GRAY"],
            font=("Consolas", 9, "bold")
        ).pack(anchor="w")
        
        progress_container = MatrixFrame(progress_frame)
        progress_container.pack(fill=tk.X, pady=5)
        
        self.progress_canvas = tk.Canvas(
            progress_container,
            height=25,
            bg=COLORS["DARK"],
            highlightthickness=0
        )
        self.progress_canvas.pack(fill=tk.X)
        
        self.progress_rect = self.progress_canvas.create_rectangle(
            0, 0, 0, 25,
            fill=COLORS["GREEN"],
            outline=""
        )
        
        self.progress_text_var = tk.StringVar(value="0%")
        progress_label = MatrixLabel(
            progress_container,
            textvariable=self.progress_text_var,
            fg=COLORS["GREEN"],
            font=("Consolas", 9, "bold")
        )
        progress_label.pack(anchor="e", pady=2)
        
        speed_frame = MatrixFrame(progress_frame)
        speed_frame.pack(fill=tk.X, pady=2)
        
        self.speed_var = tk.StringVar(value="> SPEED: 0 B/s")
        MatrixLabel(
            speed_frame,
            textvariable=self.speed_var,
            fg=COLORS["CYAN"],
            font=("Consolas", 9)
        ).pack(anchor="w")
        
        terminal_frame = MatrixFrame(main)
        terminal_frame.pack(fill=tk.BOTH, expand=True, pady=10)
        
        MatrixLabel(
            terminal_frame,
            text="╔══════ SYSTEM_LOG ══════╗",
            fg=COLORS["GRAY"],
            font=("Consolas", 9)
        ).pack(anchor="w")
        
        self.terminal = TerminalWidget(terminal_frame)
        
        MatrixLabel(
            terminal_frame,
            text="╚════════════════════════════╝",
            fg=COLORS["GRAY"],
            font=("Consolas", 9)
        ).pack(anchor="w")
        
        btn_frame2 = MatrixFrame(main)
        btn_frame2.pack(fill=tk.X, pady=5)
        
        history_btn = MatrixButton(
            btn_frame2,
            text="[>] VIEW_HISTORY",
            command=self.show_history
        )
        history_btn.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=2)
        
        clear_btn = MatrixButton(
            btn_frame2,
            text="[>] CLEAR_TERMINAL",
            command=self.terminal.clear,
            fg=COLORS["YELLOW"]
        )
        clear_btn.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=2)
        
        save_path_btn = MatrixButton(
            btn_frame2,
            text="[>] SAVE_PATH",
            command=self.save_default_location,
            fg=COLORS["CYAN"]
        )
        save_path_btn.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=2)
        
    def print_banner(self):
        self.terminal.add_line("> SYSTEM INITIALIZED", COLORS["GREEN"])
        self.terminal.add_line("> LOADING MODULES...", COLORS["CYAN"])
        self.terminal.add_line("> YT-DLP ENGINE: ONLINE", COLORS["GREEN"])
        self.terminal.add_line("> STORAGE PATH: " + str(self.download_dir), COLORS["GRAY"])
        self.terminal.add_line("> READY FOR OPERATIONS", COLORS["GREEN"])
        self.terminal.add_line("> " + "="*40, COLORS["GRAY"])
        
    def browse_location(self):
        selected = filedialog.askdirectory(
            title="SELECT OUTPUT DIRECTORY",
            initialdir=str(self.download_dir)
        )
        if selected:
            self.location_var.set(selected)
            self.download_dir = Path(selected)
            self.terminal.add_line(f"> PATH UPDATED: {selected}", COLORS["CYAN"])
    
    def save_default_location(self):
        location = self.location_var.get().strip()
        if location:
            self.download_dir = Path(location)
            self.config["download_dir"] = location
            save_config(self.config)
            self.terminal.add_line(f"> DEFAULT PATH SAVED: {location}", COLORS["GREEN"])
            self.status_var.set("PATH SAVED")
    
    def fetch_video(self):
        if self.downloading:
            return
        
        url = self.url_var.get().strip()
        if not validate_url(url):
            self.status_var.set("INVALID URL")
            self.terminal.add_line("> ERROR: INVALID YOUTUBE URL", COLORS["RED"])
            return
        
        self.status_var.set("SCANNING TARGET...")
        self.terminal.add_line(f"> INITIALIZING SCAN: {url}", COLORS["CYAN"])
        self.fetch_btn.config(state=tk.DISABLED)
        
        threading.Thread(target=self._fetch_video_thread, args=(url,), daemon=True).start()
    
    def _fetch_video_thread(self, url):
        try:
            ydl_opts = {
                'quiet': True,
                'no_warnings': True,
                'extract_flat': False,
                'force_generic_extractor': False,
            }
            
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                self.terminal.add_line("> EXTRACTING METADATA...", COLORS["CYAN"])
                info = ydl.extract_info(url, download=False)
                
                if info:
                    title = info.get('title', 'Unknown Title')
                    channel = info.get('uploader', 'Unknown Channel')
                    duration = info.get('duration', 0)
                    
                    self.root.after(0, self._update_video_info, title, channel, duration)
                    self.root.after(0, self._update_status, "TARGET LOCKED")
                    self.root.after(0, self._update_download_btn_state, tk.NORMAL)
                    self.root.after(0, self._update_fetch_btn_state, tk.NORMAL)
                    
                    self.root.after(0, self.terminal.add_line, f"> TITLE: {title[:50]}", COLORS["WHITE"])
                    self.root.after(0, self.terminal.add_line, f"> CHANNEL: {channel}", COLORS["GRAY"])
                    self.root.after(0, self.terminal.add_line, f"> DURATION: {format_time(duration)}", COLORS["GRAY"])
                    self.root.after(0, self.terminal.add_line, "> TARGET DATA EXTRACTED SUCCESSFULLY", COLORS["GREEN"])
                    
                    self.current_download_info = info
                else:
                    self.root.after(0, self._update_status, "EXTRACTION FAILED")
                    self.root.after(0, self._update_fetch_btn_state, tk.NORMAL)
                    self.root.after(0, self.terminal.add_line, "> ERROR: DATA EXTRACTION FAILED", COLORS["RED"])
                    
        except Exception as e:
            error_msg = str(e)
            self.root.after(0, self._update_status, "SCAN ERROR")
            self.root.after(0, self._update_fetch_btn_state, tk.NORMAL)
            self.root.after(0, self.terminal.add_line, f"> ERROR: {error_msg[:60]}", COLORS["RED"])
    
    def _update_video_info(self, title, channel, duration):
        self.info_title_var.set(f"> TITLE: {title[:50]}")
        self.info_channel_var.set(f"> CHANNEL: {channel}")
        self.info_duration_var.set(f"> DURATION: {format_time(duration)}")
    
    def _update_status(self, message):
        self.status_var.set(message)
    
    def _update_download_btn_state(self, state):
        self.download_btn.config(state=state)
    
    def _update_fetch_btn_state(self, state):
        self.fetch_btn.config(state=state)
    
    def start_download(self):
        if self.downloading:
            return
        
        if not self.current_download_info:
            self.terminal.add_line("> ERROR: NO TARGET DATA AVAILABLE", COLORS["RED"])
            return
        
        url = self.url_var.get().strip()
        format_type = self.format_var.get()
        quality = self.quality_var.get()
        download_path = Path(self.location_var.get().strip())
        
        try:
            download_path.mkdir(parents=True, exist_ok=True)
        except:
            self.terminal.add_line("> ERROR: CANNOT CREATE OUTPUT DIRECTORY", COLORS["RED"])
            return
        
        self.downloading = True
        self.cancel_download = False
        self.download_btn.config(state=tk.DISABLED)
        self.fetch_btn.config(state=tk.DISABLED)
        self.cancel_btn.config(state=tk.NORMAL)
        
        self.status_var.set("EXTRACTING DATA...")
        self.terminal.add_line("> INITIALIZING DATA EXTRACTION", COLORS["CYAN"])
        self.terminal.add_line(f"> FORMAT: {format_type}", COLORS["GRAY"])
        self.terminal.add_line(f"> QUALITY: {quality}", COLORS["GRAY"])
        self.terminal.add_line(f"> OUTPUT: {download_path}", COLORS["GRAY"])
        
        self.download_thread = threading.Thread(
            target=self._download_thread,
            args=(url, format_type, quality, download_path),
            daemon=True
        )
        self.download_thread.start()
    
    def _download_thread(self, url, format_type, quality, download_path):
        try:
            title = self.current_download_info.get('title', 'video')
            safe_title = safe_filename(title)[:100]
            
            if format_type == "MP4":
                ext = "mp4"
                format_spec = self._get_mp4_format_spec(quality)
            else:
                ext = "m4a"
                format_spec = "bestaudio/best"
            
            filename = f"{safe_title}.{ext}"
            filepath = download_path / filename
            
            ydl_opts = {
                'outtmpl': str(filepath),
                'format': format_spec,
                'quiet': True,
                'no_warnings': True,
                'progress_hooks': [self._progress_hook],
                'noplaylist': True,
            }
            
            if format_type == "Audio Only":
                ydl_opts.update({
                    'postprocessors': [{
                        'key': 'FFmpegExtractAudio',
                        'preferredcodec': 'm4a',
                        'preferredquality': '192',
                    }],
                    'extractaudio': True,
                })
            
            self.root.after(0, self.terminal.add_line, "> STARTING DATA TRANSFER...", COLORS["CYAN"])
            
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                ydl.download([url])
            
            if self.cancel_download:
                self.root.after(0, self._update_status, "TERMINATED")
                self.root.after(0, self.terminal.add_line, "> OPERATION TERMINATED BY USER", COLORS["RED"])
                if filepath.exists():
                    try:
                        filepath.unlink()
                        self.root.after(0, self.terminal.add_line, "> PARTIAL DATA CLEANED", COLORS["YELLOW"])
                    except:
                        pass
                self.root.after(0, self._reset_download_state)
                return
            
            self.progress_canvas.coords(self.progress_rect, 0, 0, self.progress_canvas.winfo_width(), 25)
            self.progress_text_var.set("100%")
            self.root.after(0, self._update_status, "COMPLETE")
            self.root.after(0, self.terminal.add_line, "> DATA EXTRACTION COMPLETE", COLORS["GREEN"])
            self.root.after(0, self.terminal.add_line, f"> SAVED: {filename}", COLORS["WHITE"])
            
            history_entry = {
                "title": title[:50],
                "format": format_type,
                "quality": quality,
                "filename": filename,
                "path": str(filepath),
                "timestamp": datetime.now().isoformat(),
                "status": "Completed"
            }
            self.history.append(history_entry)
            save_history(self.history)
            
            self.root.after(0, self._reset_download_state)
            
        except Exception as e:
            if not self.cancel_download:
                self.root.after(0, self._update_status, "ERROR")
                self.root.after(0, self.terminal.add_line, f"> ERROR: {str(e)[:60]}", COLORS["RED"])
            self.root.after(0, self._reset_download_state)
    
    def _get_mp4_format_spec(self, quality):
        quality_map = {
            "Best Available": "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best",
            "1080p": "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080][ext=mp4]/best",
            "720p": "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]/best",
            "480p": "bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]/best[height<=480][ext=mp4]/best",
            "360p": "bestvideo[height<=360][ext=mp4]+bestaudio[ext=m4a]/best[height<=360][ext=mp4]/best",
        }
        return quality_map.get(quality, "best[ext=mp4]/best")
    
    def _progress_hook(self, d):
        if self.cancel_download:
            raise Exception("OPERATION TERMINATED")
            
        if d['status'] == 'downloading':
            if 'total_bytes' in d:
                percent = (d['downloaded_bytes'] / d['total_bytes']) * 100
                speed = d.get('speed', 0)
                self.root.after(0, self._update_progress, percent, speed)
            elif 'total_bytes_estimate' in d:
                percent = (d['downloaded_bytes'] / d['total_bytes_estimate']) * 100
                speed = d.get('speed', 0)
                self.root.after(0, self._update_progress, percent, speed)
        elif d['status'] == 'finished':
            self.root.after(0, self._update_progress, 100, 0)
    
    def _update_progress(self, percent, speed):
        width = self.progress_canvas.winfo_width()
        if width > 0:
            progress_width = (percent / 100) * width
            self.progress_canvas.coords(self.progress_rect, 0, 0, progress_width, 25)
        self.progress_text_var.set(f"{percent:.1f}%")
        
        if speed:
            speed_str = format_size(int(speed)) + "/s"
            self.speed_var.set(f"> SPEED: {speed_str}")
        else:
            self.speed_var.set("> SPEED: 0 B/s")
    
    def cancel_download_process(self):
        if self.downloading:
            self.cancel_download = True
            self.status_var.set("TERMINATING...")
            self.terminal.add_line("> TERMINATION REQUESTED", COLORS["YELLOW"])
            self.cancel_btn.config(state=tk.DISABLED)
    
    def _reset_download_state(self):
        self.downloading = False
        self.download_btn.config(state=tk.NORMAL)
        self.fetch_btn.config(state=tk.NORMAL)
        self.cancel_btn.config(state=tk.DISABLED)
        self.cancel_download = False
        self.status_var.set("SYSTEM READY")
    
    def show_history(self):
        if not self.history:
            self.terminal.add_line("> NO HISTORY AVAILABLE", COLORS["YELLOW"])
            return
        
        history_window = tk.Toplevel(self.root)
        history_window.title("> HISTORY")
        history_window.geometry("450x600")
        history_window.configure(bg=COLORS["BG"])
        
        banner = MatrixLabel(
            history_window,
            text="╔══════ EXTRACTION_HISTORY ══════╗",
            fg=COLORS["GRAY"],
            font=("Consolas", 11, "bold")
        )
        banner.pack(pady=10)
        
        container = MatrixFrame(history_window)
        container.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)
        
        canvas = tk.Canvas(container, bg=COLORS["BG"], highlightthickness=0)
        scrollbar = tk.Scrollbar(container, orient="vertical", command=canvas.yview)
        scrollable = MatrixFrame(canvas)
        
        scrollable.bind("<Configure>", lambda e: canvas.configure(scrollregion=canvas.bbox("all")))
        canvas.create_window((0, 0), window=scrollable, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)
        
        for i, entry in enumerate(reversed(self.history)):
            frame = MatrixFrame(scrollable)
            frame.pack(fill=tk.X, pady=3)
            
            MatrixLabel(
                frame,
                text=f"[{i+1}] {entry.get('title', 'Unknown')[:45]}",
                fg=COLORS["WHITE"],
                font=("Consolas", 10, "bold")
            ).pack(anchor="w")
            
            details = f"    {entry.get('format', '')} | {entry.get('quality', '')}"
            dt = datetime.fromisoformat(entry.get('timestamp', '')).strftime("%d %b %Y")
            details += f" | {dt}"
            MatrixLabel(
                frame,
                text=details,
                fg=COLORS["GRAY"],
                font=("Consolas", 9)
            ).pack(anchor="w")
            
            status = entry.get('status', 'Completed')
            color = COLORS["GREEN"] if status == "Completed" else COLORS["RED"]
            MatrixLabel(
                frame,
                text=f"    > STATUS: {status}",
                fg=color,
                font=("Consolas", 9)
            ).pack(anchor="w")
            
            MatrixLabel(
                frame,
                text="    " + "-"*30,
                fg=COLORS["DARK"],
                font=("Consolas", 9)
            ).pack(anchor="w")
        
        canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        close_btn = MatrixButton(
            history_window,
            text="[>] CLOSE",
            command=history_window.destroy
        )
        close_btn.pack(pady=10)

def main():
    try:
        ensure_config_dir()
        root = tk.Tk()
        try:
            root.iconbitmap(default='icon.ico')
        except:
            pass
        app = HackingDownloader(root)
        root.mainloop()
    except Exception as e:
        print(f"FATAL: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
