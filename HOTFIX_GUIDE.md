# 🛠️ ppSR Offline Hotfix & Manual Patch Guide / 离线热更手动安装指南

[English](#-english) | [简体中文](#-简体中文)

---

## 🇬🇧 English

### Solving 404 CDN Hotfix Download Errors & Infinite Loading Train

#### 📌 Background & Root Cause
When launching the game with `"send_hotfix": true` in ppSR's `misc\persistent.json`, the server injects official CDN download URLs (`autopatchos.starrails.com`) into the gateway response. 

Because official beta CDN files are frequently deprecated or purged by miHoYo, these URLs return **HTTP 404 (Not Found)**. The game client gets stuck in an infinite retry loop on the loading train screen or freezes at 0% downloading resources.

To resolve this issue, players should apply the **Offline Hotfix Package** manually and disable server hotfix dispatch.

---

### 🚀 Step-by-Step Installation Guide

#### Step 1: Download the Offline Hotfix Package
Obtain the manual patch archive (e.g., `HSR_4.6.51_Offline_Hotfix.zip` or `.7z`) provided by the server host or community.

#### Step 2: Extract to Game Directory
Extract the archive directly into your Honkai: Star Rail game folder (where `StarRail.exe` is located):

```text
<Game Root Folder>/
├── StarRail.exe
├── config.ini
└── StarRail_Data/
    └── StreamingAssets/
        └── Asb/
            └── Win/          <-- Overwrite updated asset bundles here
```
> [!IMPORTANT]
> If Windows prompts that files already exist, click **"Replace the files in the destination"**.

#### Step 3: Disable Hotfix Dispatch in ppSR
1. Navigate to your ppSR directory.
2. Open `misc\persistent.json` in a text editor (Notepad, VS Code, etc.).
3. Ensure `"send_hotfix"` is set to `false`:
   ```json
   {
     "send_hotfix": false,
     "scene": { ... }
   }
   ```
4. Save the file.

#### Step 4: Launch and Play
1. Start `ppsr.exe` (or use `start_ppsr.bat`).
2. Start `gameserver.exe`.
3. Launch `StarRail.exe`.
4. The client will bypass the network download and load all new assets locally from disk!

---

### ❓ Troubleshooting FAQ

* **Q: The game still loops at the train screen after setting `send_hotfix: false`!**
  * **A**: Make sure ppSR was restarted after editing `persistent.json`. ppSR only loads `persistent.json` upon startup.
* **Q: Black screen or missing models after manually copying files?**
  * **A**: Ensure your base client version matches the server build (e.g., `4.6.51` client for `4.6.5X` server) and that all subfolders under `StarRail_Data` merged properly.

---

<br>

## 🇨🇳 简体中文

### 解决 404 CDN 热更下载失败与列车无限加载循环

#### 📌 问题原因与背景
当 ppSR 服务端的 `misc\persistent.json` 中配置了 `"send_hotfix": true` 时，网关（Gateway）会将官方 CDN 的热更下载地址（`autopatchos.starrails.com`）下发给游戏客户端。

由于米哈游官方测试服的 CDN 热更资源已过期删除，导致客户端请求时全部返回 **HTTP 404 (Not Found)**。这会导致客户端在列车加载界面陷入无限重试循环，或卡在 0% 资源下载无法进入游戏。

**完美解决方案**：采用 **离线热更补丁（Offline Patch）** 手动覆盖游戏文件，并在服务端彻底关闭热更下发。

---

### 🚀 手动安装步骤

#### 第一步：获取离线热更补丁包
下载服主或社区提供的离线热更整合压缩包（例如 `HSR_4.6.51_Offline_Hotfix.zip` 或 `.7z`）。

#### 第二步：解压并覆盖到游戏目录
将压缩包内的文件解压至包含 `StarRail.exe` 的游戏主目录：

```text
<游戏主目录>/
├── StarRail.exe
├── config.ini
└── StarRail_Data/
    └── StreamingAssets/
        └── Asb/
            └── Win/          <-- 解压并覆盖资产文件至此
```
> [!IMPORTANT]
> 若 Windows 提示目标文件夹中已包含同名文件，请务必选择 **“替换目标中的文件”**。

#### 第三步：关闭 ppSR 服务端热更下发
1. 打开 ppSR 根目录。
2. 使用文本编辑器打开 `misc\persistent.json`。
3. 确保首行的 `"send_hotfix"` 配置已设为 `false`：
   ```json
   {
     "send_hotfix": false,
     "scene": { ... }
   }
   ```
4. 保存文件。

#### 第四步：启动服务并登录游戏
1. 启动 `ppsr.exe`（或使用 `start_ppsr.bat`）。
2. 启动 `gameserver.exe`。
3. 启动 `StarRail.exe` 客户端。
4. 游戏将直接读取本地补丁资源，跳过网络下载直接秒进游戏！

---

### ❓ 常见问题排查（FAQ）

* **问：将 `send_hotfix` 改成 `false` 后，列车界面依然在转圈怎么办？**
  * **答**：ppSR 仅在启动时读取一次 `persistent.json`。修改配置后必须**彻底重启** `ppsr.exe` 才能生效。
* **问：覆盖文件后游戏黑屏、闪退或模型缺失？**
  * **答**：请检查客户端版本号是否与服务端完全一致（例如 `4.6.51` 客户端对应 `4.6.5X` 服务端），并确认 `StarRail_Data` 目录下的子文件夹结构合并正确。
