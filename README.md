# Escape Penacony Tool (ppSR Scene & Map Teleporter)
### Version 4.6.51
> *If any map you are looking for is not here, my dump tool was dumb so it doesn't have it RN lol*

An interactive, zero-hardcode CLI tool and companion utility for **ppSR** (Project Star Rail).  
Allows players and developers to easily escape Penacony and explore all planets, worlds, and maps across the game with full Calyx combat support!

---

## ✨ Features

- **🎮 8 Worlds & 90 Explorable Maps**: Includes Astral Express, Herta Space Station, Jarilo-VI (Belobog), Xianzhou Luofu, Penacony, Amphoreus, Planarcadia, and Astropolis.
- **🌅 Amphoreus Dawn & Evernight Temporal States**: Full toggle support for **Dawn** (Daytime state / Layer 1) and **Evernight** (Nighttime puzzle state / Layer 2) across all major Amphoreus puzzle zones (Okhema, Castrum Kremnos, Janusopolis, Grove of Epiphany, Styxia, Eye of Twilight, and Great Tomb of the Nameless Titan).
- **🚢 New World Additions**: Includes The Radiant Feldspar (Penacony Luxury Airship), Aurum Alley (Night Market Bazaar F4), Skysplitter (The Wardance), The Shackling Prison, Duomension Outer Border, and Neon Skylines!
- **⚔️ Integrated Calyx & Combat**: Automatically recalculates and writes native `calyx_*` spawn points, group IDs, instance IDs, and entity IDs so you can trigger combat on any map.
- **🎯 Interactive 2-Tier CLI Menu**: Clean arrow-key (`↑` / `↓` / `Enter`) terminal navigation with pagination, live details preview box, and back buttons.
- **🛡️ Rock-Solid Terminal Engine**: Zero line-wrapping, zero ghost text, and auto window-size adjustment (`mode con: cols=120 lines=32`).
- **🚀 One-Click Server Launcher (`start_ppsr.bat`)**: Launches `ppsr.exe` with UTF-8 console encoding (`chcp 65001`) preventing encoding errors with Chinese console text.
- **🌐 Zero Hardcoded Paths**: Dynamic path resolution across all Windows machines (`%USERPROFILE%`, Downloads, Desktop, relative paths).
- **➕ Custom Coordinates Support**: Option to enter custom Plane IDs and (X, Y, Z) coordinates directly.

---

## 🎮 How to Use

1. Double-click **`change_scene.bat`**.
2. Use **`[UP]`** and **`[DOWN]`** arrow keys to highlight your desired **Planet / World**.
3. Press **`[ENTER]`** to view the maps for that world.
4. Highlight your desired **Scene / Map** (or choose between **[Dawn State]** and **[Evernight State]**) and press **`[ENTER]`**.
5. The tool will instantly update `misc\persistent.json` and create an automatic backup (`persistent.json.bak`).
6. Select **`[2] Restart & Launch ppSR Server`** directly from the menu (or run **`start_ppsr.bat`**).
7. Log into the game and enjoy exploring!

---

## 📁 Repository Structure

```text
Escape-penacony/
├── change_scene.bat       # Quick batch launcher (Auto 120x32 window)
├── ppsr_teleport.ps1      # Interactive navigation engine & JSON writer
├── scenes.json            # Database of 8 worlds and 90 maps (with Dawn/Evernight states)
├── start_ppsr.bat         # UTF-8 server launcher for ppsr.exe
├── README.md              # Documentation
└── .gitignore             # Local config & temporary file exclusions
```

---

## ⚠️ Notes

- ppSR only reads `persistent.json` when the server process starts up. If the server is already running, make sure to restart it using Option `[2]` or `start_ppsr.bat`.