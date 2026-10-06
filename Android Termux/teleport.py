#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ppSR Scene & Map Teleporter Manager - Android / Termux Edition
Compatible with ppSR (Project Star Rail / 4.4.x - 4.7.x+)
Supports English (EN), ภาษาไทย (TH), and 简体中文 (ZH).
"""

import os
import sys
import json
import shutil
import argparse
from typing import Dict, Any, List, Optional, Tuple

# Ensure UTF-8 output across all environments (Windows, Termux, Linux)
if hasattr(sys.stdout, "reconfigure"):
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

VERSION = "1.0.0-Android"
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CONFIG_FILE = os.path.join(SCRIPT_DIR, "ppsr_config.json")

# Candidate scenes.json paths
SCENES_CANDIDATES = [
    os.path.join(SCRIPT_DIR, "scenes.json"),
    os.path.join(SCRIPT_DIR, "..", "scenes.json"),
]

# ANSI Colors
class Color:
    RESET = "\033[0m"
    BOLD = "\033[1m"
    DIM = "\033[2m"
    RED = "\033[91m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    BLUE = "\033[94m"
    MAGENTA = "\033[95m"
    CYAN = "\033[96m"
    WHITE = "\033[97m"
    GRAY = "\033[90m"

# ------------------------------------------------------------------------------
# Localization Dictionary (EN / TH / ZH)
# ------------------------------------------------------------------------------
I18N = {
    "en": {
        "AppTitle": f"ppSR Scene & Map Teleporter (Android Edition v{VERSION})",
        "Controls": "Input number or use controls: [1-9] Select | [B] Back | [Q] Exit",
        "ActiveLabel": "Active Location: ",
        "TargetLabel": "Target File:     ",
        "UnknownLocation": "Unknown Location",
        "MapCount": "{0} maps",
        "ActionCustom": "[+] Custom Coordinates",
        "ActionCustomDesc": "Enter Plane ID and X, Y, Z coordinates manually",
        "ActionRepath": "[*] Change persistent.json Path",
        "ActionRepathDesc": "Select a different persistent.json configuration",
        "ActionLang": "[L] Language / ภาษา / 语言",
        "ActionLangDesc": "Current: English (Click to change)",
        "ActionExit": "[X] Exit",
        "ActionExitDesc": "Close application",
        "ActionBack": "[B] Back",
        "ActionBackDesc": "Return to previous menu",
        "SelectedMapHeader": "[SELECTED MAP DETAILS]",
        "SelectedWorldHeader": "[SELECTED WORLD DETAILS]",
        "LabelName": "Name:       ",
        "LabelPlane": "Plane ID:   ",
        "LabelLayer": "Map Layer:  ",
        "LabelDesc": "Desc:       ",
        "LabelCombat": "Combat:     ",
        "LabelCoords": "Coords:     ",
        "LabelWorld": "World:      ",
        "LabelTotalMaps": "Total Maps: ",
        "ActionBoxHeader": "[ACTION]",
        "ApplyTitle": "Applying Teleport Configuration",
        "ApplySuccess": "[OK] SUCCESS: persistent.json has been updated!",
        "SummaryPlanet": "Planet:       ",
        "SummaryScene": "Scene Name:   ",
        "SummaryPlane": "Plane ID:     ",
        "SummaryCoords": "Coordinates:  ",
        "SummaryLayer": "Map Layer:    ",
        "SummaryCalyx": "Calyx Spawn:  ",
        "SummaryTarget": "Target File:  ",
        "SummaryBackup": "Backup File:  ",
        "NextPrompt": "What would you like to do next?",
        "NextOption1": "1. Teleport to another scene",
        "NextOption2": "2. Exit",
        "NextSelectPrompt": "Select option (1-2, Default: 1): ",
        "CustomDialogTitle": "[+] Enter Custom Scene / Plane Coordinates",
        "CustomDialogSub": "Type your custom plane ID and spawn coordinates:",
        "CustomPlanePrompt": "Enter Plane ID (e.g. 20461): ",
        "CustomInvalidPlane": "[!] Invalid Plane ID. Operation cancelled.",
        "CustomXPrompt": "Enter Coordinate X (e.g. 12080): ",
        "CustomYPrompt": "Enter Coordinate Y (e.g. 393572): ",
        "CustomZPrompt": "Enter Coordinate Z (e.g. 322230): ",
        "CustomLayerPrompt": "Enter Map Layer (Default: 1, Press Enter to skip): ",
        "CustomPressAnyKey": "Press Enter to return to menu...",
        "LangMenuTitle": "Select Language / เลือกภาษา / 选择语言",
        "LangMenuSub": "Choose your preferred language for menus and map names:",
        "LangOptionEN": "1. English (Default)",
        "LangOptionTH": "2. ภาษาไทย (Thai)",
        "LangOptionZH": "3. 简体中文 (Chinese)",
        "Goodbye": "Thank you for using ppSR Teleporter! Goodbye.",
        "CategoryTitle": "Select Map Category / เลือกหมวดหมู่ / 选择分类",
        "CategorySub": "Choose teleport mode (Combat vs Exploration vs Beta):",
        "CatCombat": "[⚔️] Combat Ready (Product / Calyx Supported)",
        "CatCombatDesc": "{0} Product maps with verified native Calyx combat in official client",
        "CatExplore": "[🗺️] Exploration Only (Product / Safe Scenery)",
        "CatExploreDesc": "{0} Product maps for scenery. Calyx safely hidden underground Y=-999999",
        "CatBeta": "[🧪] Beta Scenes (4.7 Beta / CBT Exclusive)",
        "CatBetaDesc": "{0} scenes exclusive to 4.7 Beta client (Requires Beta client)",
        "CatAll": "[🌐] All Worlds & Maps (Product + Beta)",
        "CatAllDesc": "{0} maps across {1} planets",
        "PlanetSelectTitle": "Select World / Planet",
        "SceneSelectTitle": "Select Map / Scene in {0}",
        "BadgeCombat": "[⚔️ Calyx]",
        "BadgeExplore": "[🗺️ Safe]",
        "BadgeBeta": "[🧪 4.7 Beta]",
        "BadgeProduct": "[Product]",
        "SummaryClient": "Client Version: ",
        "CombatSupported": "[OK] Native Calyx (Combat Ready)",
        "CombatHidden": "[Hidden] Underground Y=-999999 (No freeze)",
        "BetaWarning": "[!] WARNING: 4.7 Beta Client Required! Official Product (4.6.x) client will freeze.",
        "NoticeHeader": "[CLIENT NOTICE]",
        "InvalidChoice": "[!] Invalid choice. Please try again.",
        "PromptPersistent": "Enter path to persistent.json (or press Enter to cancel): ",
    },
    "th": {
        "AppTitle": f"ระบบเทเลพอร์ตแผนที่ ppSR (Android Edition v{VERSION})",
        "Controls": "พิมพ์ตัวเลขหรือคำสั่ง: [1-9] เลือก  |  [B] ย้อนกลับ  |  [Q] ออก",
        "ActiveLabel": "ตำแหน่งปัจจุบัน: ",
        "TargetLabel": "ไฟล์ปลายทาง:     ",
        "UnknownLocation": "ไม่ทราบตำแหน่ง",
        "MapCount": "{0} แผนที่",
        "ActionCustom": "[+] กำหนดพิกัดเอง (Custom Coordinates)",
        "ActionCustomDesc": "กรอก Plane ID และพิกัด X, Y, Z ด้วยตนเอง",
        "ActionRepath": "[*] เปลี่ยนโฟลเดอร์ persistent.json",
        "ActionRepathDesc": "เลือกไฟล์ persistent.json ในตำแหน่งอื่น",
        "ActionLang": "[L] เปลี่ยนภาษา / Language / 语言",
        "ActionLangDesc": "ปัจจุบัน: ภาษาไทย (คลิกเพื่อเปลี่ยน)",
        "ActionExit": "[X] ออกจากโปรแกรม",
        "ActionExitDesc": "ปิดหน้าต่างโปรแกรม",
        "ActionBack": "[B] ย้อนกลับ",
        "ActionBackDesc": "กลับสู่เมนูก่อนหน้า",
        "SelectedMapHeader": "[ข้อมูลแผนที่ที่เลือก]",
        "SelectedWorldHeader": "[ข้อมูลดวงดาวที่เลือก]",
        "LabelName": "ชื่อแมพ:      ",
        "LabelPlane": "Plane ID:    ",
        "LabelLayer": "ชั้นแผนที่:   ",
        "LabelDesc": "รายละเอียด:   ",
        "LabelCombat": "เสาต่อสู้:    ",
        "LabelCoords": "พิกัดเกิด:    ",
        "LabelWorld": "ดวงดาว:       ",
        "LabelTotalMaps": "จำนวนแมพ:    ",
        "ActionBoxHeader": "[คำสั่ง]",
        "ApplyTitle": "กำลังบันทึกการตั้งค่าเทเลพอร์ต",
        "ApplySuccess": "[OK] สำเร็จ: อัปเดตข้อมูลลง persistent.json เรียบร้อยแล้ว!",
        "SummaryPlanet": "ดวงดาว:        ",
        "SummaryScene": "ชื่อแผนที่:    ",
        "SummaryPlane": "Plane ID:      ",
        "SummaryCoords": "พิกัด X,Y,Z:   ",
        "SummaryLayer": "ชั้นแผนที่:   ",
        "SummaryCalyx": "สถานะ Calyx:  ",
        "SummaryTarget": "ไฟล์เป้าหมาย:  ",
        "SummaryBackup": "ไฟล์สำรอง:    ",
        "NextPrompt": "ต้องการทำอะไรต่อ?",
        "NextOption1": "1. เทเลพอร์ตไปแมพอื่น",
        "NextOption2": "2. ออกจากโปรแกรม",
        "NextSelectPrompt": "เลือกตัวเลือก (1-2, ค่าเริ่มต้น: 1): ",
        "CustomDialogTitle": "[+] ป้อนพิกัด Plane / แมพที่ต้องการเอง",
        "CustomDialogSub": "พิมพ์รหัส Plane ID และพิกัดตำแหน่งที่ต้องการเกิด:",
        "CustomPlanePrompt": "กรอก Plane ID (เช่น 20461): ",
        "CustomInvalidPlane": "[!] Plane ID ไม่ถูกต้อง ยกเลิกคำสั่ง",
        "CustomXPrompt": "กรอกพิกัด X (เช่น 12080): ",
        "CustomYPrompt": "กรอกพิกัด Y (เช่น 393572): ",
        "CustomZPrompt": "กรอกพิกัด Z (เช่น 322230): ",
        "CustomLayerPrompt": "กรอกชั้นแผนที่ Map Layer (ค่าเริ่มต้น: 1, กด Enter เพื่อข้าม): ",
        "CustomPressAnyKey": "กด Enter เพื่อกลับสู่เมนูหลัก...",
        "LangMenuTitle": "เลือกภาษาใช้งาน / Select Language / 选择语言",
        "LangMenuSub": "เลือกภาษาสำหรับเมนูและชื่อแผนที่:",
        "LangOptionEN": "1. English (อังกฤษ)",
        "LangOptionTH": "2. ภาษาไทย (Thai - ค่าเริ่มต้น)",
        "LangOptionZH": "3. 简体中文 (จีน)",
        "Goodbye": "ขอบคุณที่ใช้งาน ppSR Scene & Map Teleporter! ลาก่อนครับ",
        "CategoryTitle": "เลือกหมวดหมู่แผนที่ / Select Category",
        "CategorySub": "เลือกโหมดการเทเลพอร์ต (เน้นต่อสู้ หรือเน้นสำรวจถ่ายรูป หรือแมพ Beta):",
        "CatCombat": "[⚔️] โหมดต่อสู้ (Product / มีเสา Calyx)",
        "CatCombatDesc": "{0} แมพของตัวเกม Product ที่ตรวจสอบแล้วว่ามีเสา Calyx เปิดต่อสู้ได้จริง",
        "CatExplore": "[🗺️] โหมดสำรวจ (Product / เดินชมวิว ปลอดภัย)",
        "CatExploreDesc": "{0} แมพของตัวเกม Product สำหรับเดินชมวิว เสา Calyx ซ่อนใต้ดิน Y=-999999",
        "CatBeta": "[🧪] แผนที่ 4.7 Beta (CBT / เฉพาะตัวเกมเวอร์ชันเบต้า)",
        "CatBetaDesc": "{0} แผนที่เฉพาะตัวเกม 4.7 Beta (ต้องใช้ตัวเกม Beta 4.7)",
        "CatAll": "[🌐] รวมทุกดวงดาวและทุกแผนที่ (Product + Beta)",
        "CatAllDesc": "{0} แมพจากทั้งหมด {1} ดวงดาว",
        "PlanetSelectTitle": "เลือกดวงดาว / โลก",
        "SceneSelectTitle": "เลือกแผนที่ใน {0}",
        "BadgeCombat": "[⚔️ สู้ได้]",
        "BadgeExplore": "[🗺️ สำรวจ]",
        "BadgeBeta": "[🧪 4.7 Beta]",
        "BadgeProduct": "[Product]",
        "SummaryClient": "ประเภทรุ่นตัวเกม: ",
        "CombatSupported": "[OK] มีเสา Calyx ของแท้ (ต่อสู้ได้ทันที)",
        "CombatHidden": "[Hidden] เสาซ่อนอยู่ใต้ดิน Y=-999999 (ปลอดภัย)",
        "BetaWarning": "[!] คำเตือน: ต้องใช้ตัวเกม 4.7 Beta เท่านั้น! หากใช้ตัวเกม Product ปกติ (4.6.x) จะค้างหน้าโหลด",
        "NoticeHeader": "[ข้อสังเกตเกี่ยวกับตัวเกม]",
        "InvalidChoice": "[!] ตัวเลือกไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง",
        "PromptPersistent": "ระบุที่อยู่ไฟล์ persistent.json (หรือกด Enter เพื่อยกเลิก): ",
    },
    "zh": {
        "AppTitle": f"ppSR 场景传送与地图管理工具 (Android 版 v{VERSION})",
        "Controls": "输入序号或指令: [1-9] 选择  |  [B] 返回  |  [Q] 退出",
        "ActiveLabel": "当前所在位置: ",
        "TargetLabel": "目标配置文件: ",
        "UnknownLocation": "未知场景位置",
        "MapCount": "{0} 个场景",
        "ActionCustom": "[+] 自定义坐标传送",
        "ActionCustomDesc": "手动输入 Plane ID 与 X, Y, Z 坐标",
        "ActionRepath": "[*] 修改 persistent.json 路径",
        "ActionRepathDesc": "重新选择其他目录下的 persistent.json",
        "ActionLang": "[L] 切换语言 / Language / ภาษา",
        "ActionLangDesc": "当前语言: 简体中文 (点击切换)",
        "ActionExit": "[X] 退出程序",
        "ActionExitDesc": "关闭程序窗口",
        "ActionBack": "[B] 返回",
        "ActionBackDesc": "返回上一级菜单",
        "SelectedMapHeader": "[选中场景详情]",
        "SelectedWorldHeader": "[选中世界详情]",
        "LabelName": "场景名称:   ",
        "LabelPlane": "Plane ID:   ",
        "LabelLayer": "地图层级:   ",
        "LabelDesc": "场景介绍:   ",
        "LabelCombat": "花萼战斗:   ",
        "LabelCoords": "传送坐标:   ",
        "LabelWorld": "所属世界:   ",
        "LabelTotalMaps": "场景总数:   ",
        "ActionBoxHeader": "[功能指令]",
        "ApplyTitle": "正在保存并应用传送配置",
        "ApplySuccess": "[OK] 成功: 已更新 persistent.json 传送配置！",
        "SummaryPlanet": "所属世界:     ",
        "SummaryScene": "场景名称:     ",
        "SummaryPlane": "Plane ID:     ",
        "SummaryCoords": "传送坐标:     ",
        "SummaryLayer": "地图层级:     ",
        "SummaryClient": "客户端版本:   ",
        "SummaryCalyx": "花萼状态:     ",
        "SummaryTarget": "目标文件:     ",
        "SummaryBackup": "备份文件:     ",
        "NextPrompt": "接下来要执行的操作？",
        "NextOption1": "1. 继续传送至其他场景",
        "NextOption2": "2. 退出程序",
        "NextSelectPrompt": "请选择操作 (1-2, 默认: 1): ",
        "CustomDialogTitle": "[+] 自定义场景与坐标输入",
        "CustomDialogSub": "请输入目标 Plane ID 及生成坐标：",
        "CustomPlanePrompt": "输入 Plane ID (如 20461): ",
        "CustomInvalidPlane": "[!] 非法的 Plane ID，操作已取消。",
        "CustomXPrompt": "输入坐标 X (如 12080): ",
        "CustomYPrompt": "输入坐标 Y (如 393572): ",
        "CustomZPrompt": "输入坐标 Z (如 322230): ",
        "CustomLayerPrompt": "输入地图层级 Map Layer (默认: 1, 回车跳过): ",
        "CustomPressAnyKey": "按回车键返回主菜单...",
        "LangMenuTitle": "选择程序语言 / Select Language / เลือกภาษา",
        "LangMenuSub": "请选择界面与地图名称的显示语言：",
        "LangOptionEN": "1. English (英语)",
        "LangOptionTH": "2. ภาษาไทย (泰语)",
        "LangOptionZH": "3. 简体中文 (中文 - 默认)",
        "Goodbye": "感谢使用 ppSR 场景传送工具！再见。",
        "CategoryTitle": "选择场景分类 / Select Category",
        "CategorySub": "请选择传送模式（战斗就绪 vs 观光探索 vs 测试端）：",
        "CatCombat": "[⚔️] 战斗就绪 (正式服 / 支持花萼)",
        "CatCombatDesc": "{0} 个正式服经验证原生支持拟造花萼战斗的场景",
        "CatExplore": "[🗺️] 仅限探索 (正式服 / 安全模式)",
        "CatExploreDesc": "{0} 个正式服风景地图，花萼安全隐藏于地底 Y=-999999",
        "CatBeta": "[🧪] 4.7 Beta 测试端专属场景 (CBT)",
        "CatBetaDesc": "{0} 个仅在 4.7 Beta 测试端客户端中存在的场景 (需测试端)",
        "CatAll": "[🌐] 全部世界与完整地图 (正式服 + Beta)",
        "CatAllDesc": "{0} 个场景（涵盖全部 {1} 个世界）",
        "PlanetSelectTitle": "选择世界 / 星球",
        "SceneSelectTitle": "选择 {0} 中的具体场景",
        "BadgeCombat": "[⚔️ 战斗]",
        "BadgeExplore": "[🗺️ 安全]",
        "BadgeBeta": "[🧪 4.7 Beta]",
        "BadgeProduct": "[正式服]",
        "CombatSupported": "[OK] 原生花萼支持 (可触发战斗)",
        "CombatHidden": "[Hidden] 花萼隐藏于地底 Y=-999999 (防卡死)",
        "BetaWarning": "[!] 提示: 此场景需要 4.7 Beta 客户端！使用正式服/Product 客户端 (如 4.6.x) 进入会卡在列车加载界面！",
        "NoticeHeader": "[客户端版本提示]",
        "InvalidChoice": "[!] 输入有误，请重新输入。",
        "PromptPersistent": "请输入 persistent.json 完整路径 (回车取消): ",
    }
}

CURRENT_LANG = "en"

def t(key: str, *args) -> str:
    lang_dict = I18N.get(CURRENT_LANG, I18N["en"])
    text = lang_dict.get(key, I18N["en"].get(key, key))
    if args:
        try:
            return text.format(*args)
        except Exception:
            return text
    return text

def get_localized_name(item: Dict[str, Any]) -> str:
    if CURRENT_LANG == "th" and item.get("name_th"):
        return item["name_th"]
    if CURRENT_LANG == "zh" and item.get("name_zh"):
        return item["name_zh"]
    return item.get("name", "")

def get_localized_desc(item: Dict[str, Any]) -> str:
    if CURRENT_LANG == "th" and item.get("desc_th"):
        return item["desc_th"]
    if CURRENT_LANG == "zh" and item.get("desc_zh"):
        return item["desc_zh"]
    return item.get("desc", "")

def clear_screen():
    os.system("clear" if os.name != "nt" else "cls")

# ------------------------------------------------------------------------------
# Dynamic Scene & Version Helpers (Zero Hardcoding)
# ------------------------------------------------------------------------------
def is_beta_scene(scene: Dict[str, Any]) -> bool:
    """Check if scene belongs to Beta dynamically from metadata (Zero Hardcoding)."""
    return bool(scene.get("is_beta") or scene.get("channel") == "beta")

def get_client_channel(scene: Dict[str, Any]) -> str:
    """Return formatted client version string dynamically."""
    return scene.get("client_version") or ("4.7 Beta" if is_beta_scene(scene) else "Product")

def get_beta_notice(scene: Dict[str, Any]) -> Optional[str]:
    """Retrieve localized notice for Beta scenes."""
    if not is_beta_scene(scene):
        return None
    lang_key = f"beta_notice_{CURRENT_LANG}"
    return scene.get(lang_key) or scene.get("beta_notice") or t("BetaWarning")

# ------------------------------------------------------------------------------
# Config & Database Helpers
# ------------------------------------------------------------------------------
def load_app_config() -> Dict[str, Any]:
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            pass
    return {}

def save_app_config(cfg: Dict[str, Any]):
    try:
        with open(CONFIG_FILE, "w", encoding="utf-8") as f:
            json.dump(cfg, f, indent=2, ensure_ascii=False)
    except Exception:
        pass

def find_scenes_json(custom_path: Optional[str] = None) -> Optional[str]:
    if custom_path and os.path.isfile(custom_path):
        return os.path.abspath(custom_path)
    env_path = os.environ.get("PPSR_SCENES_PATH")
    if env_path and os.path.isfile(env_path):
        return os.path.abspath(env_path)
    for path in SCENES_CANDIDATES:
        if os.path.isfile(path):
            return os.path.abspath(path)
    return None

def load_scenes_database(scenes_path: str) -> Optional[List[Dict[str, Any]]]:
    try:
        with open(scenes_path, "r", encoding="utf-8") as f:
            data = json.load(f)
            return data.get("planets", [])
    except Exception as e:
        print(f"{Color.RED}[!] Failed to parse scenes.json: {e}{Color.RESET}")
        return None

def find_persistent_json(custom_path: Optional[str] = None) -> Optional[str]:
    if custom_path and os.path.isfile(custom_path):
        return os.path.abspath(custom_path)
    env_path = os.environ.get("PPSR_PERSISTENT_PATH")
    if env_path and os.path.isfile(env_path):
        return os.path.abspath(env_path)

    cfg = load_app_config()
    cfg_path = cfg.get("persistent_path")
    if cfg_path and os.path.isfile(cfg_path):
        return os.path.abspath(cfg_path)

    # Search candidates across Android/Termux and common paths
    home = os.path.expanduser("~")
    candidates = [
        os.path.join(SCRIPT_DIR, "persistent.json"),
        os.path.join(SCRIPT_DIR, "misc", "persistent.json"),
        os.path.join(SCRIPT_DIR, "..", "persistent.json"),
        os.path.join(SCRIPT_DIR, "..", "misc", "persistent.json"),
        os.path.join(home, "ppSR", "misc", "persistent.json"),
        os.path.join(home, "ppSR", "persistent.json"),
        "/sdcard/ppSR/misc/persistent.json",
        "/sdcard/ppSR/persistent.json",
        "/sdcard/Download/ppSR/misc/persistent.json",
    ]
    for cand in candidates:
        if os.path.isfile(cand):
            resolved = os.path.abspath(cand)
            cfg["persistent_path"] = resolved
            save_app_config(cfg)
            return resolved
    return None

# ------------------------------------------------------------------------------
# Teleport Application
# ------------------------------------------------------------------------------
def apply_scene_teleport(target_path: str, scene: Dict[str, Any], planet_name: str) -> bool:
    clear_screen()
    print(f"{Color.CYAN}{'=' * 70}{Color.RESET}")
    print(f"  {Color.YELLOW}{t('ApplyTitle')}{Color.RESET}")
    print(f"{Color.CYAN}{'=' * 70}{Color.RESET}\n")

    try:
        # Create backup
        bak_path = f"{target_path}.bak"
        shutil.copyfile(target_path, bak_path)

        with open(target_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        if "scene" not in data or not isinstance(data["scene"], dict):
            data["scene"] = {}

        x = int(scene.get("x", 0))
        y = int(scene.get("y", 0))
        z = int(scene.get("z", 0))
        plane_id = int(scene.get("plane_id", 0))
        map_layer = int(scene.get("map_layer", 1))

        calyx_x = int(scene["calyx_x"]) if scene.get("calyx_x") is not None else x
        calyx_y = int(scene["calyx_y"]) if scene.get("calyx_y") is not None else y
        calyx_z = int(scene["calyx_z"]) if scene.get("calyx_z") is not None else (z + 1800)

        calyx_group_id = int(scene.get("calyx_group_id", 186))
        calyx_inst_id = int(scene.get("calyx_inst_id", 300001))
        calyx_entity_id = int(scene.get("calyx_entity_id", 1337))
        calyx_prop_id = int(scene.get("calyx_prop_id", 808))

        data["scene"]["plane_id"] = plane_id
        data["scene"]["x"] = x
        data["scene"]["y"] = y
        data["scene"]["z"] = z
        data["scene"]["calyx_x"] = calyx_x
        data["scene"]["calyx_y"] = calyx_y
        data["scene"]["calyx_z"] = calyx_z
        data["scene"]["map_layer"] = map_layer
        data["scene"]["calyx_group_id"] = calyx_group_id
        data["scene"]["calyx_inst_id"] = calyx_inst_id
        data["scene"]["calyx_entity_id"] = calyx_entity_id
        data["scene"]["calyx_prop_id"] = calyx_prop_id

        # Write clean UTF-8 without BOM
        with open(target_path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        print(f"  {Color.GREEN}{t('ApplySuccess')}{Color.RESET}")
        print(f"  {Color.GRAY}{'-' * 60}{Color.RESET}")
        print(f"  {t('SummaryPlanet')}{Color.YELLOW}{planet_name}{Color.RESET}")
        print(f"  {t('SummaryScene')}{Color.CYAN}{get_localized_name(scene)}{Color.RESET}")
        print(f"  {t('SummaryPlane')}{Color.MAGENTA}{plane_id}{Color.RESET}")
        print(f"  {t('SummaryCoords')}{Color.GREEN}X: {x} | Y: {y} | Z: {z}{Color.RESET}")
        print(f"  {t('SummaryLayer')}{Color.CYAN}{map_layer}{Color.RESET}")

        # Client Channel (Product vs Beta)
        is_beta = is_beta_scene(scene)
        chan_str = get_client_channel(scene)
        chan_color = Color.MAGENTA if is_beta else Color.BLUE
        print(f"  {t('SummaryClient')}{chan_color}{chan_str}{Color.RESET}")

        if scene.get("calyx_supported"):
            calyx_str = f"X: {calyx_x} | Y: {calyx_y} | Z: {calyx_z} (Group {calyx_group_id}, Inst {calyx_inst_id}) {t('CombatSupported')}"
            print(f"  {t('SummaryCalyx')}{Color.GREEN}{calyx_str}{Color.RESET}")
        else:
            print(f"  {t('SummaryCalyx')}{Color.YELLOW}{t('CombatHidden')}{Color.RESET}")

        print(f"  {t('SummaryTarget')}{Color.GRAY}{target_path}{Color.RESET}")
        print(f"  {t('SummaryBackup')}{Color.GRAY}{bak_path}{Color.RESET}")

        if is_beta:
            notice = get_beta_notice(scene)
            if notice:
                print(f"  {Color.GRAY}{'-' * 60}{Color.RESET}")
                print(f"  {Color.YELLOW}{Color.BOLD}{t('NoticeHeader')}{Color.RESET}")
                print(f"  {Color.YELLOW}{notice}{Color.RESET}")

        print(f"  {Color.GRAY}{'-' * 60}{Color.RESET}\n")
        return True
    except Exception as e:
        print(f"\n  {Color.RED}[X] FAILED to update persistent.json: {e}{Color.RESET}")
        return False

# ------------------------------------------------------------------------------
# Interactive Menus
# ------------------------------------------------------------------------------
def prompt_language_selection():
    global CURRENT_LANG
    clear_screen()
    print(f"{Color.CYAN}{'=' * 70}{Color.RESET}")
    print(f"  {Color.YELLOW}{t('LangMenuTitle')}{Color.RESET}")
    print(f"  {Color.GRAY}{t('LangMenuSub')}{Color.RESET}")
    print(f"{Color.CYAN}{'=' * 70}{Color.RESET}\n")

    print(f"  1. English")
    print(f"  2. ภาษาไทย (Thai)")
    print(f"  3. 简体中文 (Chinese)\n")

    choice = input(f"  Select (1-3, Default: 1): ").strip()
    if choice == "2":
        CURRENT_LANG = "th"
    elif choice == "3":
        CURRENT_LANG = "zh"
    else:
        CURRENT_LANG = "en"

    cfg = load_app_config()
    cfg["language"] = CURRENT_LANG
    save_app_config(cfg)

def prompt_custom_coordinates(target_path: str):
    clear_screen()
    print(f"{Color.CYAN}{'=' * 70}{Color.RESET}")
    print(f"  {Color.YELLOW}{t('CustomDialogTitle')}{Color.RESET}")
    print(f"  {Color.GRAY}{t('CustomDialogSub')}{Color.RESET}")
    print(f"{Color.CYAN}{'=' * 70}{Color.RESET}\n")

    try:
        plane_str = input(f"  {t('CustomPlanePrompt')}").strip()
        if not plane_str.isdigit():
            print(f"\n  {Color.RED}{t('CustomInvalidPlane')}{Color.RESET}")
            input(f"\n  {t('CustomPressAnyKey')}")
            return

        x = int(input(f"  {t('CustomXPrompt')}").strip())
        y = int(input(f"  {t('CustomYPrompt')}").strip())
        z = int(input(f"  {t('CustomZPrompt')}").strip())
        layer_str = input(f"  {t('CustomLayerPrompt')}").strip()
        map_layer = int(layer_str) if layer_str.isdigit() else 1

        custom_scene = {
            "name": f"Custom Plane {plane_str}",
            "name_th": f"พิกัดกำหนดเอง Plane {plane_str}",
            "name_zh": f"自定义场景 Plane {plane_str}",
            "plane_id": int(plane_str),
            "x": x,
            "y": y,
            "z": z,
            "map_layer": map_layer,
            "calyx_supported": False,
            "calyx_y": -999999,
        }
        apply_scene_teleport(target_path, custom_scene, "Custom Coordinates")
        input(f"  {t('CustomPressAnyKey')}")
    except Exception as e:
        print(f"\n  {Color.RED}[!] Error: {e}{Color.RESET}")
        input(f"  {t('CustomPressAnyKey')}")

def prompt_persistent_path() -> Optional[str]:
    clear_screen()
    print(f"{Color.YELLOW}{'=' * 70}{Color.RESET}")
    print(f"  {Color.RED}[!] persistent.json not found automatically{Color.RESET}")
    print(f"{Color.YELLOW}{'=' * 70}{Color.RESET}\n")
    print(f"  Please enter the full path to your persistent.json:")
    print(f"  (Example: /sdcard/ppSR/misc/persistent.json or ~/ppSR/misc/persistent.json)\n")

    val = input(f"  {t('PromptPersistent')}").strip().strip('"').strip("'")
    if not val:
        return None

    expanded = os.path.expanduser(val)
    if os.path.isdir(expanded):
        cand1 = os.path.join(expanded, "misc", "persistent.json")
        cand2 = os.path.join(expanded, "persistent.json")
        if os.path.isfile(cand1):
            expanded = cand1
        elif os.path.isfile(cand2):
            expanded = cand2

    if os.path.isfile(expanded):
        cfg = load_app_config()
        cfg["persistent_path"] = os.path.abspath(expanded)
        save_app_config(cfg)
        return os.path.abspath(expanded)

    print(f"\n  {Color.RED}[X] Invalid path or file does not exist!{Color.RESET}")
    input("  Press Enter to continue...")
    return None

# ------------------------------------------------------------------------------
# Main Application Loop
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# Automated Self-Tests
# ------------------------------------------------------------------------------
def run_self_tests(target_override: Optional[str] = None, scenes_override: Optional[str] = None):
    print(f"\n{Color.CYAN}[TEST] Starting automated self-test...{Color.RESET}")
    scenes_path = find_scenes_json(scenes_override)
    assert scenes_path, "scenes.json not found"
    print(f"{Color.GREEN}[PASS] scenes.json resolved: {scenes_path}{Color.RESET}")

    planets = load_scenes_database(scenes_path)
    assert planets, "Failed to load planets database"
    total = sum(len(p.get("scenes", [])) for p in planets)
    beta = sum(sum(1 for s in p.get("scenes", []) if is_beta_scene(s)) for p in planets)
    product = total - beta
    print(f"{Color.GREEN}[PASS] Loaded {len(planets)} worlds, {total} scenes ({product} Product, {beta} Beta){Color.RESET}")
    assert beta > 0, "No beta scenes identified"
    assert product > 0, "No product scenes identified"

    # Test dummy teleport
    import tempfile
    td = tempfile.mkdtemp()
    dummy = os.path.join(td, "persistent.json")
    with open(dummy, "w", encoding="utf-8") as f:
        json.dump({"scene": {"plane_id": 10000, "x": 0, "y": 0, "z": 0}, "key": ""}, f)

    first_scene = planets[0]["scenes"][0]
    ok = apply_scene_teleport(dummy, first_scene, planets[0]["name"])
    assert ok, "apply_scene_teleport failed"
    with open(dummy, "r", encoding="utf-8") as f:
        d = json.load(f)
    assert d["scene"]["plane_id"] == first_scene["plane_id"]
    assert d.get("key") == ""
    print(f"{Color.GREEN}[PASS] apply_scene_teleport executed cleanly with zero error{Color.RESET}")
    print(f"{Color.GREEN}[PASS] ALL SELF-TESTS PASSED SUCCESSFULLY!{Color.RESET}\n")

# ------------------------------------------------------------------------------
# Main Application Loop
# ------------------------------------------------------------------------------
def main():
    global CURRENT_LANG

    parser = argparse.ArgumentParser(description="ppSR Scene & Map Teleporter - Android Edition")
    parser.add_argument("-p", "--persistent", help="Path to persistent.json")
    parser.add_argument("-s", "--scenes", help="Path to scenes.json")
    parser.add_argument("-l", "--lang", choices=["en", "th", "zh"], help="Interface language (en/th/zh)")
    parser.add_argument("-m", "--mode", choices=["combat", "explore", "beta", "all"], help="Initial filter mode")
    parser.add_argument("--test", action="store_true", help="Run automated test suite")
    args, unknown = parser.parse_known_args()

    # Load initial language from args or config
    cfg = load_app_config()
    if args.lang:
        CURRENT_LANG = args.lang
    else:
        CURRENT_LANG = cfg.get("language", "en")

    if CURRENT_LANG not in I18N:
        CURRENT_LANG = "en"

    # Self-test mode
    if args.test:
        run_self_tests(args.persistent, args.scenes)
        return

    # Resolve persistent.json
    persistent_path = find_persistent_json(args.persistent)
    while not persistent_path:
        persistent_path = prompt_persistent_path()
        if not persistent_path:
            choice = input(f"Retry? (y/n): ").strip().lower()
            if choice != 'y':
                print(f"{Color.YELLOW}{t('Goodbye')}{Color.RESET}")
                return

    # Load scenes database
    scenes_path = find_scenes_json(args.scenes)
    if not scenes_path:
        print(f"{Color.RED}[!] Error: scenes.json not found in {SCRIPT_DIR}!{Color.RESET}")
        return

    planets = load_scenes_database(scenes_path)
    if not planets:
        print(f"{Color.RED}[!] Error: Failed to load scenes database from {scenes_path}!{Color.RESET}")
        return

    while True:
        # Check active location
        curr_loc_str = t("UnknownLocation")
        try:
            with open(persistent_path, "r", encoding="utf-8") as f:
                cur_data = json.load(f).get("scene", {})
                curr_plane = cur_data.get("plane_id")
                for p in planets:
                    for s in p.get("scenes", []):
                        if s.get("plane_id") == curr_plane:
                            curr_loc_str = f"{get_localized_name(s)} [{get_localized_name(p)}] (Plane {curr_plane})"
                            break
        except Exception:
            pass

        clear_screen()
        print(f"{Color.CYAN}{'=' * 70}{Color.RESET}")
        print(f"  {Color.YELLOW}{Color.BOLD}{t('AppTitle')}{Color.RESET}")
        print(f"  {Color.GRAY}{t('ActiveLabel')}{Color.WHITE}{curr_loc_str}{Color.RESET}")
        print(f"  {Color.GRAY}{t('TargetLabel')}{Color.DARK_GRAY if hasattr(Color, 'DARK_GRAY') else Color.GRAY}{persistent_path}{Color.RESET}")
        print(f"{Color.CYAN}{'=' * 70}{Color.RESET}")
        print(f"  {Color.YELLOW}{t('CategoryTitle')}{Color.RESET}")
        print(f"  {Color.GRAY}{t('CategorySub')}{Color.RESET}")
        print(f"{Color.CYAN}{'-' * 70}{Color.RESET}\n")

        # Category options
        total_maps = sum(len(p.get("scenes", [])) for p in planets)
        beta_maps = sum(sum(1 for s in p.get("scenes", []) if is_beta_scene(s)) for p in planets)
        combat_maps = sum(sum(1 for s in p.get("scenes", []) if s.get("calyx_supported") and not is_beta_scene(s)) for p in planets)
        explore_maps = sum(sum(1 for s in p.get("scenes", []) if not s.get("calyx_supported") and not is_beta_scene(s)) for p in planets)

        print(f"  {Color.GREEN}1.{Color.RESET} {t('CatCombat')} ({combat_maps} maps)")
        print(f"  {Color.CYAN}2.{Color.RESET} {t('CatExplore')} ({explore_maps} maps)")
        print(f"  {Color.MAGENTA}3.{Color.RESET} {t('CatBeta')} ({beta_maps} maps)")
        print(f"  {Color.WHITE}4.{Color.RESET} {t('CatAll')} ({total_maps} maps)")
        print(f"  {Color.YELLOW}5.{Color.RESET} {t('ActionCustom')}")
        print(f"  {Color.MAGENTA}L.{Color.RESET} {t('ActionLang')}")
        print(f"  {Color.BLUE}P.{Color.RESET} {t('ActionRepath')}")
        print(f"  {Color.RED}Q.{Color.RESET} {t('ActionExit')}\n")

        cat_choice = input(f"  Select option (1-5, L, P, Q): ").strip().lower()

        if cat_choice in ["q", "x", "exit"]:
            print(f"\n  {Color.YELLOW}{t('Goodbye')}{Color.RESET}")
            break
        elif cat_choice == "l":
            prompt_language_selection()
            continue
        elif cat_choice == "p":
            new_path = prompt_persistent_path()
            if new_path:
                persistent_path = new_path
            continue
        elif cat_choice == "5":
            prompt_custom_coordinates(persistent_path)
            continue

        filter_mode = "all"
        if cat_choice == "1":
            filter_mode = "combat"
        elif cat_choice == "2":
            filter_mode = "explore"
        elif cat_choice == "3":
            filter_mode = "beta"
        elif cat_choice == "4":
            filter_mode = "all"
        else:
            continue

        # Planet Selection Loop
        while True:
            # Filter planets
            filtered_planets = []
            for p in planets:
                p_scenes = p.get("scenes", [])
                if filter_mode == "combat":
                    matched = [s for s in p_scenes if s.get("calyx_supported") and not is_beta_scene(s)]
                elif filter_mode == "explore":
                    matched = [s for s in p_scenes if not s.get("calyx_supported") and not is_beta_scene(s)]
                elif filter_mode == "beta":
                    matched = [s for s in p_scenes if is_beta_scene(s)]
                else:
                    matched = p_scenes

                if matched:
                    filtered_planets.append((p, matched))

            clear_screen()
            print(f"{Color.CYAN}{'=' * 70}{Color.RESET}")
            print(f"  {Color.YELLOW}{t('PlanetSelectTitle')}{Color.RESET}")
            print(f"  {Color.GRAY}{t('Controls')}{Color.RESET}")
            print(f"{Color.CYAN}{'-' * 70}{Color.RESET}\n")

            for idx, (p, matched) in enumerate(filtered_planets, start=1):
                p_name = get_localized_name(p)
                print(f"  {Color.GREEN}{idx:2d}.{Color.RESET} {p_name} {Color.GRAY}({len(matched)} maps){Color.RESET}")

            print(f"\n  {Color.YELLOW} B. {t('ActionBack')}{Color.RESET}\n")
            p_input = input(f"  Select Planet (1-{len(filtered_planets)}, B): ").strip().lower()

            if p_input in ["b", "back", "q"]:
                break

            if not p_input.isdigit() or not (1 <= int(p_input) <= len(filtered_planets)):
                continue

            sel_planet, sel_scenes = filtered_planets[int(p_input) - 1]
            planet_name = get_localized_name(sel_planet)

            # Scene Selection Loop
            while True:
                clear_screen()
                print(f"{Color.CYAN}{'=' * 70}{Color.RESET}")
                print(f"  {Color.YELLOW}{t('SceneSelectTitle', planet_name)}{Color.RESET}")
                print(f"  {Color.GRAY}{t('Controls')}{Color.RESET}")
                print(f"{Color.CYAN}{'-' * 70}{Color.RESET}\n")

                for idx, sc in enumerate(sel_scenes, start=1):
                    sc_name = get_localized_name(sc)
                    p_id = sc.get("plane_id")
                    if is_beta_scene(sc):
                        chan_badge = f"{Color.MAGENTA}{t('BadgeBeta')}{Color.RESET}"
                    else:
                        chan_badge = f"{Color.BLUE}{t('BadgeProduct')}{Color.RESET}"
                    calyx_badge = f"{Color.GREEN}{t('BadgeCombat')}{Color.RESET}" if sc.get("calyx_supported") else f"{Color.YELLOW}{t('BadgeExplore')}{Color.RESET}"
                    print(f"  {Color.GREEN}{idx:2d}.{Color.RESET} {sc_name} {Color.GRAY}[Plane {p_id}]{Color.RESET} {chan_badge} {calyx_badge}")

                print(f"\n  {Color.YELLOW} B. {t('ActionBack')}{Color.RESET}\n")
                s_input = input(f"  Select Scene (1-{len(sel_scenes)}, B): ").strip().lower()

                if s_input in ["b", "back", "q"]:
                    break

                if not s_input.isdigit() or not (1 <= int(s_input) <= len(sel_scenes)):
                    continue

                chosen_scene = sel_scenes[int(s_input) - 1]
                applied = apply_scene_teleport(persistent_path, chosen_scene, planet_name)

                if applied:
                    print(f"  {Color.YELLOW}{t('NextPrompt')}{Color.RESET}")
                    print(f"  {Color.CYAN}{t('NextOption1')}{Color.RESET}")
                    print(f"  {Color.RED}{t('NextOption2')}{Color.RESET}\n")
                    nxt = input(f"  {t('NextSelectPrompt')}").strip()
                    if nxt == "2":
                        print(f"\n  {Color.YELLOW}{t('Goodbye')}{Color.RESET}")
                        return
                    # Otherwise loop back to select another
                    break

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n\n  {Color.YELLOW}Interrupted. Goodbye!{Color.RESET}")
        sys.exit(0)
