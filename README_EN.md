<div align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:00aaff,100:0055ff&height=180&section=header&text=ITSFOUR%20HUB&fontSize=40&fontColor=ffffff&fontAlignY=35&desc=Universal%20Aimbot%20%26%20ESP%20Module%20for%20Roblox&descSize=15&descAlignY=60" width="100%" alt="ITSFOUR HUB"/>

  <br>

  [🇻🇳 Tiếng Việt](README.md) · [🇬🇧 **English**](README_EN.md)

  <br>

  ![Release](https://img.shields.io/badge/Release-v3.0-00aaff?style=for-the-badge&logo=github)
  ![Roblox](https://img.shields.io/badge/Roblox-Script-00A2FF?style=for-the-badge&logo=roblox&logoColor=white)
  [![License](https://img.shields.io/badge/License-MIT-success?style=for-the-badge)](LICENSE)
  ![Lua](https://img.shields.io/badge/Language-Lua-000080?style=for-the-badge&logo=lua&logoColor=white)

  **Universal Aimbot, Triggerbot, Tracer, and ESP with a Glass UI.**
</div>

---

## 📖 Introduction

**ITSFOUR HUB** is a Lua script for Roblox developed by **itsfour**. It provides a configurable interface for Aimbot, Triggerbot, and visual features such as FOV, Tracer, and ESP.

> **Scope note:** In the current source, ESP iterates through Roblox's `Players` list. NPC support should not be advertised until NPC functionality is actually implemented and tested.

## ✨ Features

### 🎯 Aimbot
- Enable or disable Aimbot and choose a target part: `Head`, `HumanoidRootPart`, or `Torso`.
- Optional team, alive-state, and visibility/wall checks.
- Adjust target-lock smoothing and mouse-control sensitivity.
- Optional movement-direction offset with an adjustable offset amount.
- Supports the camera/mouse control modes implemented in the source.

### 🔫 Triggerbot
- Enable or disable Triggerbot.
- Optional team check, alive check, and aim-locked-only condition.
- Configurable activation delay.
- Requires an executor that supports the relevant mouse simulation functions; without them, Triggerbot may not work.

### 👁️ Visuals: FOV, Tracer, and ESP
- **FOV:** enable/disable the FOV circle and adjust its radius and color.
- **Tracer:** draw a line to the closest target and customize its color and origin.
- **ESP:** configure head dots, display names, distances, text sizes, and colors.
- Optional teammate filtering for ESP.

### 🎨 Interface and utilities
- Draggable Glass UI.
- Press **RightShift** to show or hide the menu.
- The **EN/VN** button switches the interface language in-place.
- Saves some settings to `itsfour_auto_config.json` if the executor supports file read/write APIs.
- Not every interface property is persisted, so some changes may not be restored.

## 🚀 Setup / Launch

1. Upload the script file to your repository.
2. Copy the exact **Raw URL** for the Lua file.
3. Replace the placeholder URL below with your Raw URL, then run it in a compatible environment.

```lua
loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
```

`YOUR_RAW_URL_HERE` is a placeholder, not a working URL.

## ⌨️ Default controls

| Key / control | Action |
|---|---|
| `RightShift` | Show/hide the interface |
| Right mouse button (`MouseButton2`) | Default Aimbot activation input |
| `EN` / `VN` button | Switch interface language |

Aimbot uses hold-to-activate by default (`Toggle = false`). Settings can be changed in the script's configuration table; not every option has a dedicated GUI control.

## ⚙️ Environment requirements

Compatibility depends on the executor and the APIs it provides. The source uses or optionally uses APIs including:

- `Drawing.new` for the FOV, Tracer, and ESP drawings.
- `getgenv` for storing configuration in the execution environment.
- `getrawmetatable` and corresponding property access helpers.
- `mousemoverel` or `Input.MouseMove` for one mouse-control mode.
- `mousemoveabs` for absolute mouse movement, if available.
- `mouse1press`, `mouse1release`, and `mouse1click` for Triggerbot.
- `readfile`, `writefile`, and `isfile` for optional configuration persistence.

If required APIs are unavailable, some features may not work or the script may error. Compatibility has not been verified for every executor.

## 💾 Configuration file

When file APIs are available, the script saves configuration to:

```text
itsfour_auto_config.json
```

Saved data may include Aimbot, Triggerbot, Tracer, ESP, some FOV settings, and the selected language. Back up or remove this file if an old configuration causes unexpected behavior.

## 🐛 Issues and contributions

When reporting a problem, include:
- Executor name and platform.
- The full error message.
- Steps to reproduce the issue.
- The feature and settings enabled when the issue occurred.

Share only relevant diagnostic information. Do not attach cookies, tokens, or personal account data.

## 📜 Copyright

**Developer:** [itsfour](https://github.com/itsfourvn)

Copyright © 2026 itsfour. All rights reserved.

See the repository's [`LICENSE`](LICENSE) file for the applicable terms. Avoid claiming both MIT and CC0 unless the repository clearly defines its official licensing.
