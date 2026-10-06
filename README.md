# Escape Penacony Tool (ppSR Scene & Map Teleporter)

An interactive, zero-hardcode CLI tool and companion utility for **ppSR** 
Allows players to easily escape Penacony and explore all maps across the game with full Calyx combat support(Just kidding it not lmao)

[English](../README.md) · [简体中文](docs/README_ZH.md)

![terminal look](./Picture.png)
---

## ✨ Features

- **🌐 Trilingual Localization (EN / TH / ZH)**:
  - English (EN)
  - ภาษาไทย (TH)
  - 简体中文 (ZH)
  - Switch languages seamlessly on the fly with the **`[L]`** menu option or via `ppsr_config.json`.
- **🎯 100% Ground-Truth Teleport Coordinates**:
  - Every single spawn coordinate is directly extracted from official `res.json` and `scene_config` teleporters. if it worng scene my dump tool is dumb
  - Fixes all character floating in midair
- **⚔️ Calyx Mode & Category Filtering**:
  - Filter maps before selecting worlds: **[⚔️] Combat Ready (Calyx Supported)** vs **[🗺️] Exploration Only (Safe Mode)** vs **[🌐] All Maps**.
  - In Exploration maps, Calyx is safely placed underground (`Y = -999999`) to eliminate accidental interaction and infinite loading freezes.
  - In Combat maps, verified native Calyx properties (Group ID & Inst ID) are placed for smooth battle triggers.
- **🚀 One-Click ppSR Server Restart**:
  - Automatically restarts `ppsr.exe` in its own UTF-8 console window (`chcp 65001`), eliminating encoding errors with Chinese console text.
  (dir scan only desktop and download folder)

---

## 🎮 How to Use / วิธีใช้งาน / 使用方法

1. Double-click **`change_scene.bat`**.
2. Select your language by pressing **`[L]`** (English / ภาษาไทย / 简体中文).
3. Select your desired mode: **[⚔️] Combat Ready**, **[🗺️] Exploration Only**, or **[🌐] All Maps**.
4. Use **`[UP]`** and **`[DOWN]`** arrow keys to highlight your desired **Planet / World**.
5. Press **`[ENTER]`** to view the maps for that world.
6. Highlight your desired **Scene / Map** and press **`[ENTER]`**.
7. The tool updates `persistent.json` and makes a backup (`persistent.json.bak`).
8. Select **`[2] Restart & Launch ppSR Server`** directly from the menu.
9. Log into the game and enjoy!

---

## 📁 Repository Structure

```text
Escape-penacony/
├── change_scene.bat       # Quick batch launcher (Auto 120x32 window)
├── ppsr_teleport.ps1      # Interactive navigation engine (EN/TH/ZH)
├── scenes.json            # Database of 8 worlds and 83 maps (Multilingual)
├── start_ppsr.bat         # UTF-8 server launcher for ppsr.exe
├── README.md              # Documentation
└── .gitignore             # Local config & temporary file exclusions
```

---

## ⚠️ Notes

- ppSR only reads `persistent.json` when the server starts up. If the server is already running, restart it using Option `[2]` or `start_ppsr.bat`.

---

## 💖 Credits & Acknowledgements

- Special thanks to **Oriyuki** for providing the accurate Chinese map localization and translation dictionary! (特别感谢 **Oriyuki** 提供完整的中文地图场景名称翻译与定位校对！)
=======
