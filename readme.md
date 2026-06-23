# Zig bad apple

simple project built with **Zig (0.14.1)** and **C (Miniaudio)**. running on terminal, using **Delta Timing** to prevent audio drift.

---

## Features
- **Audio-Video Sync**: Uses hardware-based Delta Timing instead of unreliable thread sleeping.
- **Fast RAM Streaming**: Loads the entire ASCII asset into memory once (`Pointer Slicing`), executing frames thousands of times faster than standard file-based Python scripts.


---

## Requirements & Dependencies



1. **Zig Compiler**: Version `0.14.1` (Ensure its added to your system environment variables/PATH).

2. **FFmpeg**: Required for extracting `.mp4` video frames into raw images.

3. **ASCII Image Converter CLI**: Developed by `@TheZoraiz`. Installed globally via Windows Package Manager.

4. **Miniaudio C**: A single-header audio playback library (`miniaudio.h`).

---

## 🛠️ Installation & Preparation Guide

Follow these exact steps to clone, convert assets, and run the multimedia player on your machine:

### 1. Setup the Project Directory
Clone or create your project directory and make sure your internal file structure looks exactly like this:
```text
zigsandbox/
├── build.zig
├── bad_apple.mp3             # bad apple mp3 here
├── bad_apple_all.txt         # your final big ascii txt
└── src/
    ├── main.zig
    ├── miniaudio.c
    └── miniaudio.h
```

### 2. Generate the Animated ASCII Asset (The Sysadmin Way)
If you want to re-convert the video from scratch without causing file explorer lag:
1. Put your `bad_apple.mp4` video inside your working directory.
2. Install the ASCII converter utility using Windows Terminal:
   ```bash
   winget install TheZoraiz.ascii-image-converter
   ```
3. Extract the video frames using FFmpeg (optimized at 15 FPS with an 80:30 terminal canvas ratio well you can change this):
   ```bash
   mkdir temp_frames
   ffmpeg -i bad_apple.mp4 -vf "fps=15,scale=80:30" temp_frames/img_%04d.png
   ```
4. Create the target text output directory:
   ```bash
   mkdir txt_out
   ```
5. Convert all generated frames into standardized pure text modules:
   ```bash
   for %f in (temp_frames\*.png) do ascii-image-converter "%f" --save-txt txt_out
   ```
6. Stitch all individual frames into a single high-density system asset separated by the `SPLIT` flag:
   ```bash
   for %f in (txt_out\*.txt) do (type "%f" >> bad_apple_all.txt & echo SPLIT >> bad_apple_all.txt)
   ```

---

## 🎮 How to Run

Once `bad_apple_all.txt` and `bad_apple.mp3` are successfully seated in the root folder, purge your old compiler build logs and launch the engine:

```bash
# Compile and play the bad apple :)
zig build run
```

Press `Ctrl + C` in your terminal anytime to kill the audio process and exit the player.

---

