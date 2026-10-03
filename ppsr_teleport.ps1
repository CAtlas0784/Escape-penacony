# ==============================================================================
#  ppSR Scene & Map Teleporter Manager (Multilingual Edition: EN / TH / ZH)
#  Compatible with ppSR (Project Star Rail / 4.4.x - 4.6.x+)
# ==============================================================================

param(
    [switch]$Test,
    [string]$TargetFile = "",
    [int]$SelectPlane = 0,
    [string]$Lang = ""
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
try { [Console]::InputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $ScriptDir) { $ScriptDir = $PWD.Path }

$ConfigPath = Join-Path $ScriptDir "ppsr_config.json"
$ScenesPath = Join-Path $ScriptDir "scenes.json"

# ------------------------------------------------------------------------------
# Localization Dictionary (EN / TH / ZH)
# ------------------------------------------------------------------------------
$I18N = @{
    en = @{
        AppTitle            = "ppSR Scene & Map Teleporter"
        Controls            = "Controls: [UP/DOWN] Navigate  |  [ENTER] Select  |  [ESC] Go Back"
        ActiveLabel         = "Active: "
        TargetLabel         = "Target: "
        UnknownLocation     = "Unknown Location"
        MapCount            = "{0} maps"
        ActionCustom        = "[+] Custom Coordinates"
        ActionCustomDesc    = "Enter Plane ID and X, Y, Z coordinates manually"
        ActionRepath        = "[*] Change persistent.json Path"
        ActionRepathDesc    = "Select a different persistent.json configuration"
        ActionLang          = "[L] Language / ภาษา / 语言"
        ActionLangDesc      = "Current: English (Click to change)"
        ActionExit          = "[X] Exit"
        ActionExitDesc      = "Close application"
        ActionBack          = "[<-] Back to World Selection"
        ActionBackDesc      = "Return to planet list"
        SelectedMapHeader   = "[SELECTED MAP DETAILS]"
        SelectedWorldHeader = "[SELECTED WORLD DETAILS]"
        LabelName           = "Name:     "
        LabelPlane          = "Plane ID: "
        LabelLayer          = "Map Layer: "
        LabelDesc           = "Desc:     "
        LabelCombat         = "Combat:   "
        LabelCoords         = "Coords:   "
        LabelWorld          = "World:    "
        LabelTotalMaps      = "Total:    "
        LabelPreview        = "Preview:  "
        ActionBoxHeader     = "[ACTION]"
        ApplyTitle          = "Applying Teleport Configuration"
        ApplySuccess        = "[OK] SUCCESS: persistent.json has been updated!"
        SummaryPlanet       = "Planet:        "
        SummaryScene        = "Scene Name:    "
        SummaryPlane        = "Plane ID:      "
        SummaryCoords       = "Coordinates:   "
        SummaryLayer        = "Map Layer:     "
        SummaryCalyx        = "Calyx Spawn:   "
        SummaryTarget       = "Target File:   "
        SummaryBackup       = "Backup File:   "
        NextPrompt          = "What would you like to do next?"
        NextOption1         = "[1] Teleport to another scene"
        NextOption2Server   = "[2] Restart & Launch ppSR Server (ppsr.exe)"
        NextOption2Exit     = "[2] Exit"
        NextOption3Exit     = "[3] Exit"
        NextSelectPrompt    = "Select option ({0}, Default: 1)"
        CheckingServer      = "[*] Checking running ppSR server..."
        LaunchingServer     = "[*] Launching ppSR Server in dedicated console window..."
        CustomDialogTitle   = "[+] Enter Custom Scene / Plane Coordinates"
        CustomDialogSub     = "Type your custom plane ID and spawn coordinates:"
        CustomPlanePrompt   = "Enter Plane ID (e.g. 20461)"
        CustomInvalidPlane  = "[!] Invalid Plane ID. Operation cancelled."
        CustomXPrompt       = "Enter Coordinate X (e.g. 12080)"
        CustomYPrompt       = "Enter Coordinate Y (e.g. 393572)"
        CustomZPrompt       = "Enter Coordinate Z (e.g. 322230)"
        CustomLayerPrompt   = "Enter Map Layer (Default: 1, Press Enter to skip)"
        CustomPressAnyKey   = "Press any key to return to menu..."
        LangMenuTitle       = "Select Application Language / เลือกภาษา / 选择语言"
        LangMenuSub         = "Choose your preferred language for menus and map names:"
        LangOptionEN        = "1. English (Default)"
        LangOptionTH        = "2. ภาษาไทย (Thai)"
        LangOptionZH        = "3. 简体中文 (Chinese)"
        Goodbye             = "Thank you for using ppSR Scene & Map Teleporter! Goodbye."
        MoreItemsAbove      = "▲▲▲  (More items above...)"
        MoreItemsBelow      = "▼▼▼  (More items below...)"
    }
    th = @{
        AppTitle            = "ระบบเทเลพอร์ตแผนที่ ppSR (Escape Penacony Tool)"
        Controls            = "การควบคุม: [ขึ้น/ลง] เลื่อนเลือก  |  [ENTER] ยืนยัน  |  [ESC] ย้อนกลับ"
        ActiveLabel         = "ตำแหน่งปัจจุบัน: "
        TargetLabel         = "ไฟล์ปลายทาง: "
        UnknownLocation     = "ไม่ทราบตำแหน่ง"
        MapCount            = "{0} แผนที่"
        ActionCustom        = "[+] กำหนดพิกัดเอง (Custom Coordinates)"
        ActionCustomDesc    = "กรอก Plane ID และพิกัด X, Y, Z ด้วยตนเอง"
        ActionRepath        = "[*] เปลี่ยนโฟลเดอร์ persistent.json"
        ActionRepathDesc    = "เลือกไฟล์ persistent.json ในตำแหน่งอื่น"
        ActionLang          = "[L] เปลี่ยนภาษา / Language / 语言"
        ActionLangDesc      = "ปัจจุบัน: ภาษาไทย (คลิกเพื่อเปลี่ยน)"
        ActionExit          = "[X] ออกจากโปรแกรม"
        ActionExitDesc      = "ปิดหน้าต่างโปรแกรม"
        ActionBack          = "[<-] ย้อนกลับไปเลือกดวงดาว"
        ActionBackDesc      = "กลับสู่รายการดวงดาวทั้งหมด"
        SelectedMapHeader   = "[ข้อมูลแผนที่ที่เลือก]"
        SelectedWorldHeader = "[ข้อมูลดวงดาวที่เลือก]"
        LabelName           = "ชื่อแมพ:    "
        LabelPlane          = "Plane ID:   "
        LabelLayer          = "ชั้นแผนที่: "
        LabelDesc           = "รายละเอียด: "
        LabelCombat         = "เสาต่อสู้:  "
        LabelCoords         = "พิกัดเกิด:  "
        LabelWorld          = "ดวงดาว:     "
        LabelTotalMaps      = "จำนวนแมพ:   "
        LabelPreview        = "ตัวอย่าง:   "
        ActionBoxHeader     = "[คำสั่ง]"
        ApplyTitle          = "กำลังบันทึกการตั้งค่าเทเลพอร์ต"
        ApplySuccess        = "[OK] สำเร็จ: อัปเดตข้อมูลลง persistent.json เรียบร้อยแล้ว!"
        SummaryPlanet       = "ดวงดาว:        "
        SummaryScene        = "ชื่อแผนที่:    "
        SummaryPlane        = "Plane ID:      "
        SummaryCoords       = "พิกัด X,Y,Z:   "
        SummaryLayer        = "ชั้นแผนที่:    "
        SummaryCalyx        = "จุดเสา Calyx:  "
        SummaryTarget       = "ไฟล์ปลายทาง:   "
        SummaryBackup       = "ไฟล์สำรอง:     "
        NextPrompt          = "ต้องการทำอะไรต่อ?"
        NextOption1         = "[1] เทเลพอร์ตไปแผนที่อื่นต่อ"
        NextOption2Server   = "[2] รีสตาร์ทและเปิดเซิร์ฟเวอร์ ppSR ทันที (ppsr.exe)"
        NextOption2Exit     = "[2] ออกจากโปรแกรม"
        NextOption3Exit     = "[3] ออกจากโปรแกรม"
        NextSelectPrompt    = "เลือกตัวเลือก ({0}, ค่าเริ่มต้น: 1)"
        CheckingServer      = "[*] กำลังตรวจสอบเซิร์ฟเวอร์ ppSR ที่เปิดอยู่..."
        LaunchingServer     = "[*] กำลังเปิดเซิร์ฟเวอร์ ppSR ในหน้าต่างคอนโซล UTF-8..."
        CustomDialogTitle   = "[+] ป้อนพิกัดแผนที่/Plane ID ด้วยตนเอง"
        CustomDialogSub     = "กรอก Plane ID และพิกัดตำแหน่งที่ต้องการเกิด:"
        CustomPlanePrompt   = "กรอก Plane ID (เช่น 20461)"
        CustomInvalidPlane  = "[!] Plane ID ไม่ถูกต้อง ยกเลิกคำสั่ง"
        CustomXPrompt       = "กรอกพิกัด X (เช่น 12080)"
        CustomYPrompt       = "กรอกพิกัด Y (เช่น 393572)"
        CustomZPrompt       = "กรอกพิกัด Z (เช่น 322230)"
        CustomLayerPrompt   = "กรอก Map Layer (ค่าเริ่มต้น: 1, กด Enter เพื่อข้าม)"
        CustomPressAnyKey   = "กดปุ่มใดๆ เพื่อกลับสู่เมนูหลัก..."
        LangMenuTitle       = "เลือกภาษาใช้งาน / Select Language / 选择语言"
        LangMenuSub         = "เลือกภาษาที่ต้องการแสดงผลในเมนูและรายชื่อแผนที่:"
        LangOptionEN        = "1. English (ภาษาอังกฤษ)"
        LangOptionTH        = "2. ภาษาไทย (Thai - ค่าแนะนำ)"
        LangOptionZH        = "3. 简体中文 (ภาษาจีนตัวย่อ)"
        Goodbye             = "ขอบคุณที่ใช้งาน ppSR Scene & Map Teleporter! แล้วพบกันใหม่ครับ"
        MoreItemsAbove      = "▲▲▲  (มีรายการด้านบนเพิ่มเติม...)"
        MoreItemsBelow      = "▼▼▼  (มีรายการด้านล่างเพิ่มเติม...)"
    }
    zh = @{
        AppTitle            = "ppSR 场景与地图传送管理器 (Escape Penacony)"
        Controls            = "操作说明: [↑/↓] 移动光标  |  [ENTER] 确认选择  |  [ESC] 返回上一级"
        ActiveLabel         = "当前地图: "
        TargetLabel         = "目标配置: "
        UnknownLocation     = "未知地图区域"
        MapCount            = "{0} 张地图"
        ActionCustom        = "[+] 自定义输入坐标 (Custom Coordinates)"
        ActionCustomDesc    = "手动输入 Plane ID 与 X, Y, Z 坐标"
        ActionRepath        = "[*] 更改 persistent.json 文件路径"
        ActionRepathDesc    = "重新指定其他 persistent.json 配置文件"
        ActionLang          = "[L] 切换语言 / Language / ภาษา"
        ActionLangDesc      = "当前: 简体中文 (点击切换)"
        ActionExit          = "[X] 退出程序"
        ActionExitDesc      = "关闭传送工具"
        ActionBack          = "[<-] 返回世界星区选择"
        ActionBackDesc      = "返回星穹世界列表"
        SelectedMapHeader   = "[选中地图详情]"
        SelectedWorldHeader = "[选中世界信息]"
        LabelName           = "名称:     "
        LabelPlane          = "位面 ID:  "
        LabelLayer          = "地图层级: "
        LabelDesc           = "区域说明: "
        LabelCombat         = "拟造花萼: "
        LabelCoords         = "坐标数据: "
        LabelWorld          = "所属世界: "
        LabelTotalMaps      = "地图总数: "
        LabelPreview        = "包含区域: "
        ActionBoxHeader     = "[操作选项]"
        ApplyTitle          = "正在应用地图传送配置"
        ApplySuccess        = "[OK] 成功: persistent.json 已成功更新！"
        SummaryPlanet       = "星穹世界:      "
        SummaryScene        = "目标地图:      "
        SummaryPlane        = "位面 ID:       "
        SummaryCoords       = "空间坐标:      "
        SummaryLayer        = "地图层级:      "
        SummaryCalyx        = "花萼生成点:    "
        SummaryTarget       = "目标文件:      "
        SummaryBackup       = "自动备份:      "
        NextPrompt          = "接下来您想执行什么操作？"
        NextOption1         = "[1] 继续传送至其他地图"
        NextOption2Server   = "[2] 重启并立即运行 ppSR 服务端 (ppsr.exe)"
        NextOption2Exit     = "[2] 退出程序"
        NextOption3Exit     = "[3] 退出程序"
        NextSelectPrompt    = "选择选项 ({0}, 默认: 1)"
        CheckingServer      = "[*] 正在检查当前运行的 ppSR 服务端进程..."
        LaunchingServer     = "[*] 正在 UTF-8 控制台独立窗口中启动 ppSR 服务端..."
        CustomDialogTitle   = "[+] 手动输入位面与场景坐标"
        CustomDialogSub     = "请输入自定义 Plane ID 与空间坐标参数:"
        CustomPlanePrompt   = "输入 Plane ID (例如: 20461)"
        CustomInvalidPlane  = "[!] Plane ID 格式无效，操作已取消。"
        CustomXPrompt       = "输入坐标 X (例如: 12080)"
        CustomYPrompt       = "输入坐标 Y (例如: 393572)"
        CustomZPrompt       = "输入坐标 Z (例如: 322230)"
        CustomLayerPrompt   = "输入地图层级 Map Layer (默认: 1, 直接回车跳过)"
        CustomPressAnyKey   = "按任意键返回上一级菜单..."
        LangMenuTitle       = "选择语言 / Select Language / เลือกภาษา"
        LangMenuSub         = "请选择菜单与地图名称所使用的语言:"
        LangOptionEN        = "1. English (英语)"
        LangOptionTH        = "2. ภาษาไทย (泰语)"
        LangOptionZH        = "3. 简体中文 (Chinese - 推荐)"
        Goodbye             = "感谢使用 ppSR 场景地图传送管理器！再见。"
        MoreItemsAbove      = "▲▲▲  (上方还有更多地图...)"
        MoreItemsBelow      = "▼▼▼  (下方还有更多地图...)"
    }
}

# ------------------------------------------------------------------------------
# Language Helper Functions
# ------------------------------------------------------------------------------
function Get-AppConfig {
    if (Test-Path $ConfigPath) {
        try {
            return Get-Content -Raw -Encoding UTF8 $ConfigPath | ConvertFrom-Json
        } catch {}
    }
    return [PSCustomObject]@{ persistent_path = ""; language = "en" }
}

function Save-AppConfig {
    param([string]$Path, [string]$Language)
    $cfg = Get-AppConfig
    if ($Path) { $cfg.persistent_path = $Path }
    if ($Language) { $cfg.language = $Language }
    $json = $cfg | ConvertTo-Json
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ConfigPath, $json, $utf8NoBom)
}

$cfgObj = Get-AppConfig
$Script:CurrentLang = if ($Lang) { $Lang } elseif ($cfgObj.language) { $cfgObj.language } else { "en" }
if (-not $I18N.ContainsKey($Script:CurrentLang)) { $Script:CurrentLang = "en" }

function T {
    param(
        [string]$Key,
        [object[]]$FormatArgs
    )
    $dict = $I18N[$Script:CurrentLang]
    if (-not $dict -or -not $dict.ContainsKey($Key)) {
        $dict = $I18N["en"]
    }
    $val = $dict[$Key]
    if ($FormatArgs -and $FormatArgs.Count -gt 0) {
        try {
            return [string]::Format($val, $FormatArgs)
        } catch {
            return $val
        }
    }
    return $val
}

function Get-LocalizedName {
    param([PSCustomObject]$Item)
    if (-not $Item) { return "" }
    if ($Script:CurrentLang -eq "th" -and $Item.name_th) { return $Item.name_th }
    if ($Script:CurrentLang -eq "zh" -and $Item.name_zh) { return $Item.name_zh }
    return $Item.name
}

function Get-LocalizedDesc {
    param([PSCustomObject]$Item)
    if (-not $Item) { return "" }
    if ($Script:CurrentLang -eq "th" -and $Item.desc_th) { return $Item.desc_th }
    if ($Script:CurrentLang -eq "zh" -and $Item.desc_zh) { return $Item.desc_zh }
    return $Item.desc
}

# ------------------------------------------------------------------------------
# Helpers: Find persistent.json
# ------------------------------------------------------------------------------
function Find-PersistentJson {
    if ($TargetFile -and (Test-Path $TargetFile)) {
        return (Resolve-Path $TargetFile).Path
    }

    # 1. Check saved config
    if (Test-Path $ConfigPath) {
        try {
            $cfg = Get-Content -Raw -Encoding UTF8 $ConfigPath | ConvertFrom-Json
            if ($cfg.persistent_path -and (Test-Path $cfg.persistent_path)) {
                return $cfg.persistent_path
            }
        } catch {}
    }

    # 2. Check candidate paths relative to script / working dir
    $candidates = @(
        (Join-Path $ScriptDir "misc\persistent.json"),
        (Join-Path $ScriptDir "..\misc\persistent.json"),
        (Join-Path $ScriptDir "persistent.json"),
        (Join-Path $PWD.Path "misc\persistent.json"),
        (Join-Path $PWD.Path "persistent.json")
    )

    # 3. Dynamic scan across user profile directories (Downloads & Desktop) without any hardcoded username
    $userProfile = [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
    if ($userProfile) {
        $downloadsDir = Join-Path $userProfile "Downloads"
        $desktopDir = Join-Path $userProfile "Desktop"

        foreach ($base in @($downloadsDir, $desktopDir)) {
            if (Test-Path $base) {
                Get-ChildItem -Path $base -Filter "persistent.json" -Recurse -Depth 4 -ErrorAction SilentlyContinue | ForEach-Object {
                    $candidates += $_.FullName
                }
            }
        }
    }

    foreach ($cand in $candidates) {
        if (Test-Path $cand) {
            return (Resolve-Path $cand).Path
        }
    }

    return $null
}

function Clear-ScreenSafely {
    try {
        Clear-Host
    } catch {
        # ignore error when console output is redirected
    }
}

function Prompt-PersistentPath {
    Clear-ScreenSafely
    Write-Host "================================================================================" -ForegroundColor Yellow
    Write-Host "  [!] persistent.json Not Found Automatically" -ForegroundColor Red
    Write-Host "================================================================================" -ForegroundColor Yellow
    Write-Host "  Please enter the full path to your persistent.json (or drag and drop the file):" -ForegroundColor White
    Write-Host "  (Example: C:\ppSR\misc\persistent.json or your ppSR folder)" -ForegroundColor DarkGray
    Write-Host ""
    $inputPath = Read-Host "  Path"
    if (-not $inputPath) { return $null }
    $inputPath = $inputPath.Trim('"').Trim("'")

    if (Test-Path $inputPath) {
        if ((Get-Item $inputPath).PSIsContainer) {
            $subPath = Join-Path $inputPath "misc\persistent.json"
            if (Test-Path $subPath) {
                Save-AppConfig -Path $subPath
                return (Resolve-Path $subPath).Path
            }
            $subPath2 = Join-Path $inputPath "persistent.json"
            if (Test-Path $subPath2) {
                Save-AppConfig -Path $subPath2
                return (Resolve-Path $subPath2).Path
            }
        } else {
            Save-AppConfig -Path $inputPath
            return (Resolve-Path $inputPath).Path
        }
    }

    Write-Host "`n  [X] Invalid path. Press any key to retry..." -ForegroundColor Red
    [Console]::ReadKey($true) | Out-Null
    return $null
}

# ------------------------------------------------------------------------------
# Helpers: Load Scenes Database
# ------------------------------------------------------------------------------
function Get-ScenesDatabase {
    if (-not (Test-Path $ScenesPath)) {
        Write-Host "  [!] scenes.json not found at: $ScenesPath" -ForegroundColor Red
        return $null
    }

    try {
        $raw = Get-Content -Raw -Encoding UTF8 $ScenesPath
        $data = $raw | ConvertFrom-Json
        return $data.planets
    } catch {
        Write-Host "  [!] Failed to parse scenes.json: $_" -ForegroundColor Red
        return $null
    }
}

# ------------------------------------------------------------------------------
# Interactive Scrolling Menu
# ------------------------------------------------------------------------------
function Show-InteractiveMenu {
    param(
        [string]$Title,
        [string]$Subtitle,
        [array]$Items,
        [int]$InitialIndex = 0,
        [int]$PageSize = 9
    )

    if ($Items.Count -le $PageSize) {
        return Show-InteractiveMenuSimple -Title $Title -Subtitle $Subtitle -Items $Items -InitialIndex $InitialIndex
    } else {
        return Show-InteractiveScrollingMenu -Title $Title -Subtitle $Subtitle -Items $Items -InitialIndex $InitialIndex -PageSize $PageSize
    }
}

function Show-InteractiveMenuSimple {
    param(
        [string]$Title,
        [string]$Subtitle,
        [array]$Items,
        [int]$InitialIndex = 0
    )

    $sel = [Math]::Max(0, [Math]::Min($Items.Count - 1, $InitialIndex))

    while ($true) {
        Clear-ScreenSafely
        Write-Host "================================================================================" -ForegroundColor Cyan
        Write-Host "  $Title" -ForegroundColor Yellow
        if ($Subtitle) {
            foreach ($subLine in ($Subtitle -split "`n")) {
                Write-Host "  $($subLine.Trim())" -ForegroundColor DarkGray
            }
        }
        Write-Host "================================================================================" -ForegroundColor Cyan
        Write-Host "  $(T 'Controls')" -ForegroundColor Yellow
        Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkGray

        for ($i = 0; $i -lt $Items.Count; $i++) {
            $it = $Items[$i]
            if ($i -eq $sel) {
                Write-Host "  ► $($it.Label)" -ForegroundColor Green -BackgroundColor Black
            } else {
                Write-Host "    $($it.Label)" -ForegroundColor Gray
            }
        }

        Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkGray
        $curData = $Items[$sel].Data

        if ($curData -is [PSCustomObject] -and $curData.plane_id) {
            Write-Host "  $(T 'SelectedMapHeader')" -ForegroundColor DarkCyan
            Write-Host "  $(T 'LabelName')$(Get-LocalizedName $curData)" -ForegroundColor White
            Write-Host "  $(T 'LabelPlane')$($curData.plane_id)   |   $(T 'LabelLayer')$($curData.map_layer)" -ForegroundColor Cyan
            Write-Host "  $(T 'LabelDesc')$(Get-LocalizedDesc $curData)" -ForegroundColor DarkGray
            Write-Host "  $(T 'LabelCombat')Calyx Prop 808 (Group $($curData.calyx_group_id), Inst $($curData.calyx_inst_id))" -ForegroundColor Yellow
            Write-Host "  $(T 'LabelCoords')X: $($curData.x) | Y: $($curData.y) | Z: $($curData.z)" -ForegroundColor DarkYellow
        }
        elseif ($curData -is [PSCustomObject] -and $curData.scenes) {
            Write-Host "  $(T 'SelectedWorldHeader')" -ForegroundColor DarkCyan
            Write-Host "  $(T 'LabelWorld')$(Get-LocalizedName $curData)" -ForegroundColor White
            Write-Host "  $(T 'LabelTotalMaps')$(T 'MapCount' @($curData.scenes.Count))" -ForegroundColor Cyan
            $previewSample = ($curData.scenes | Select-Object -First 3 | ForEach-Object { Get-LocalizedName $_ }) -join ", "
            Write-Host "  $(T 'LabelPreview')$previewSample..." -ForegroundColor DarkGray
        }
        else {
            Write-Host "  $(T 'ActionBoxHeader')" -ForegroundColor DarkCyan
            Write-Host "  $($Items[$sel].Label)" -ForegroundColor White
            Write-Host "  $($Items[$sel].Desc)" -ForegroundColor DarkGray
        }
        Write-Host "================================================================================" -ForegroundColor Cyan

        $key = [Console]::ReadKey($true)
        if ($key.Key -eq [ConsoleKey]::UpArrow) {
            $sel = ($sel - 1 + $Items.Count) % $Items.Count
        }
        elseif ($key.Key -eq [ConsoleKey]::DownArrow) {
            $sel = ($sel + 1) % $Items.Count
        }
        elseif ($key.Key -eq [ConsoleKey]::Enter) {
            return $sel
        }
        elseif ($key.Key -eq [ConsoleKey]::Escape -or $key.Key -eq [ConsoleKey]::Q) {
            return -1
        }
    }
}

function Show-InteractiveScrollingMenu {
    param(
        [string]$Title,
        [string]$Subtitle,
        [array]$Items,
        [int]$InitialIndex = 0,
        [int]$PageSize = 9
    )

    $sel = [Math]::Max(0, [Math]::Min($Items.Count - 1, $InitialIndex))
    $topVisible = [Math]::Max(0, $sel - [Math]::Floor($PageSize / 2))
    if ($topVisible + $PageSize -gt $Items.Count) {
        $topVisible = [Math]::Max(0, $Items.Count - $PageSize)
    }

    $maxLine = 80
    $writeRow = {
        param([string]$Text, [ConsoleColor]$Fg = [ConsoleColor]::Gray, [ConsoleColor]$Bg = [ConsoleColor]::Black)
        $t = $Text
        if ($t.Length -gt $maxLine) {
            $t = $t.Substring(0, $maxLine)
        } else {
            $t = $t.PadRight($maxLine)
        }
        Write-Host $t -ForegroundColor $Fg -BackgroundColor $Bg
    }

    Clear-ScreenSafely
    & $writeRow ("=" * $maxLine) DarkCyan Black
    & $writeRow "  $Title" Cyan Black
    if ($Subtitle) {
        foreach ($subLine in ($Subtitle -split "`n")) {
            & $writeRow "  $($subLine.Trim())" DarkGray Black
        }
    }
    & $writeRow ("=" * $maxLine) DarkCyan Black
    & $writeRow "  $(T 'Controls')" Yellow Black
    & $writeRow ("-" * $maxLine) DarkGray Black

    $startRow = 0
    try { $startRow = [Console]::CursorTop } catch { $startRow = 0 }
    try { [Console]::CursorVisible = $false } catch { }

    try {
        while ($true) {
            if ($sel -lt $topVisible) {
                $topVisible = $sel
            }
            elseif ($sel -ge ($topVisible + $PageSize)) {
                $topVisible = $sel - $PageSize + 1
            }

            try { [Console]::SetCursorPosition(0, $startRow) } catch { }

            if ($topVisible -gt 0) {
                & $writeRow "     $(T 'MoreItemsAbove')" DarkYellow Black
            } else {
                & $writeRow "" Gray Black
            }

            $limit = [Math]::Min($Items.Count, $topVisible + $PageSize)
            for ($i = $topVisible; $i -lt $limit; $i++) {
                $it = $Items[$i]
                $isSelected = ($i -eq $sel)

                if ($isSelected) {
                    & $writeRow "  ► $($it.Label)" Green Black
                } else {
                    & $writeRow "    $($it.Label)" Gray Black
                }
            }

            $rendered = $limit - $topVisible
            for ($k = $rendered; $k -lt $PageSize; $k++) {
                & $writeRow "" Gray Black
            }

            if ($limit -lt $Items.Count) {
                & $writeRow "     $(T 'MoreItemsBelow')" DarkYellow Black
            } else {
                & $writeRow "" Gray Black
            }

            # Live Selected Details Box
            & $writeRow ("-" * $maxLine) DarkGray Black
            $curItem = $Items[$sel]
            $curData = $curItem.Data

            if ($curData -is [PSCustomObject] -and $curData.plane_id) {
                & $writeRow "  $(T 'SelectedMapHeader')" DarkCyan Black
                & $writeRow "  $(T 'LabelName')$(Get-LocalizedName $curData)" White Black
                & $writeRow "  $(T 'LabelPlane')$($curData.plane_id)   |   $(T 'LabelLayer')$($curData.map_layer)" Cyan Black
                & $writeRow "  $(T 'LabelDesc')$(Get-LocalizedDesc $curData)" DarkGray Black
                & $writeRow "  $(T 'LabelCombat')Calyx Prop 808 (Group $($curData.calyx_group_id), Inst $($curData.calyx_inst_id))" Yellow Black
                & $writeRow "  $(T 'LabelCoords')X: $($curData.x) | Y: $($curData.y) | Z: $($curData.z)" DarkYellow Black
            }
            elseif ($curData -is [PSCustomObject] -and $curData.scenes) {
                & $writeRow "  $(T 'SelectedWorldHeader')" DarkCyan Black
                & $writeRow "  $(T 'LabelWorld')$(Get-LocalizedName $curData)" White Black
                & $writeRow "  $(T 'LabelTotalMaps')$(T 'MapCount' @($curData.scenes.Count))" Cyan Black
                $previewSample = ($curData.scenes | Select-Object -First 3 | ForEach-Object { Get-LocalizedName $_ }) -join ", "
                & $writeRow "  $(T 'LabelPreview')$previewSample..." DarkGray Black
                & $writeRow "" Gray Black
                & $writeRow "" Gray Black
            }
            else {
                & $writeRow "  $(T 'ActionBoxHeader')" DarkCyan Black
                & $writeRow "  $($curItem.Label)" White Black
                & $writeRow "  $($curItem.Desc)" DarkGray Black
                & $writeRow "" Gray Black
                & $writeRow "" Gray Black
                & $writeRow "" Gray Black
            }
            & $writeRow ("=" * $maxLine) DarkCyan Black

            $key = [Console]::ReadKey($true)
            if ($key.Key -eq [ConsoleKey]::UpArrow) {
                $sel = ($sel - 1 + $Items.Count) % $Items.Count
            }
            elseif ($key.Key -eq [ConsoleKey]::DownArrow) {
                $sel = ($sel + 1) % $Items.Count
            }
            elseif ($key.Key -eq [ConsoleKey]::PageUp) {
                $sel = [Math]::Max(0, $sel - $PageSize)
            }
            elseif ($key.Key -eq [ConsoleKey]::PageDown) {
                $sel = [Math]::Min($Items.Count - 1, $sel + $PageSize)
            }
            elseif ($key.Key -eq [ConsoleKey]::Home) {
                $sel = 0
            }
            elseif ($key.Key -eq [ConsoleKey]::End) {
                $sel = $Items.Count - 1
            }
            elseif ($key.Key -eq [ConsoleKey]::Enter) {
                return $sel
            }
            elseif ($key.Key -eq [ConsoleKey]::Escape -or $key.Key -eq [ConsoleKey]::Q) {
                return -1
            }
        }
    }
    finally {
        try { [Console]::CursorVisible = $true } catch { }
    }
}

# ------------------------------------------------------------------------------
# Update persistent.json
# ------------------------------------------------------------------------------
function Apply-SceneTeleport {
    param(
        [string]$Target,
        [PSCustomObject]$Scene,
        [string]$PlanetName
    )

    Clear-ScreenSafely
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  $(T 'ApplyTitle')" -ForegroundColor Yellow
    Write-Host "================================================================================" -ForegroundColor Cyan

    try {
        # Backup original
        $bakPath = "$Target.bak"
        Copy-Item -Path $Target -Destination $bakPath -Force

        # Read JSON
        $raw = Get-Content -Raw -Encoding UTF8 $Target
        $data = $raw | ConvertFrom-Json

        # Ensure scene object exists
        if (-not $data.scene) {
            $data | Add-Member -MemberType NoteProperty -Name "scene" -Value ([PSCustomObject]@{})
        }

        # Determine coordinates
        $x = [int]$Scene.x
        $y = [int]$Scene.y
        $z = [int]$Scene.z
        $planeId = [int]$Scene.plane_id
        $mapLayer = if ($Scene.map_layer) { [int]$Scene.map_layer } else { 1 }

        # Determine calyx placement
        $calyxX = if ($Scene.calyx_x) { [int]$Scene.calyx_x } else { $x }
        $calyxY = if ($Scene.calyx_y) { [int]$Scene.calyx_y } else { $y }
        $calyxZ = if ($Scene.calyx_z) { [int]$Scene.calyx_z } else { [int]($z + 1800) }

        $calyxGroupId = if ($Scene.calyx_group_id) { [int]$Scene.calyx_group_id } else { 186 }
        $calyxInstId = if ($Scene.calyx_inst_id) { [int]$Scene.calyx_inst_id } else { 300001 }
        $calyxEntityId = if ($Scene.calyx_entity_id) { [int]$Scene.calyx_entity_id } else { 1337 }
        $calyxPropId = if ($Scene.calyx_prop_id) { [int]$Scene.calyx_prop_id } else { 808 }

        # Update fields
        $data.scene.plane_id = $planeId
        $data.scene.x = $x
        $data.scene.y = $y
        $data.scene.z = $z
        $data.scene.calyx_x = $calyxX
        $data.scene.calyx_y = $calyxY
        $data.scene.calyx_z = $calyxZ
        $data.scene.map_layer = $mapLayer
        $data.scene.calyx_group_id = $calyxGroupId
        $data.scene.calyx_inst_id = $calyxInstId
        $data.scene.calyx_entity_id = $calyxEntityId
        $data.scene.calyx_prop_id = $calyxPropId

        # Save back to file strictly without UTF-8 BOM so Python json.load() won't crash
        $outJson = $data | ConvertTo-Json -Depth 10
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($Target, $outJson, $utf8NoBom)

        # Output Summary
        Write-Host "`n  $(T 'ApplySuccess')" -ForegroundColor Green
        Write-Host "  ----------------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host "  $(T 'SummaryPlanet')" -NoNewline -ForegroundColor White; Write-Host $PlanetName -ForegroundColor Yellow
        Write-Host "  $(T 'SummaryScene')" -NoNewline -ForegroundColor White; Write-Host (Get-LocalizedName $Scene) -ForegroundColor Cyan
        Write-Host "  $(T 'SummaryPlane')" -NoNewline -ForegroundColor White; Write-Host $planeId -ForegroundColor Magenta
        Write-Host "  $(T 'SummaryCoords')" -NoNewline -ForegroundColor White; Write-Host "X: $x | Y: $y | Z: $z" -ForegroundColor Green
        Write-Host "  $(T 'SummaryLayer')" -NoNewline -ForegroundColor White; Write-Host $mapLayer -ForegroundColor DarkCyan
        Write-Host "  $(T 'SummaryCalyx')" -NoNewline -ForegroundColor White; Write-Host "X: $calyxX | Y: $calyxY | Z: $calyxZ (Prop: $calyxPropId)" -ForegroundColor DarkYellow
        Write-Host "  $(T 'SummaryTarget')" -NoNewline -ForegroundColor White; Write-Host $Target -ForegroundColor DarkGray
        Write-Host "  $(T 'SummaryBackup')" -NoNewline -ForegroundColor White; Write-Host $bakPath -ForegroundColor DarkGray
        Write-Host "  ----------------------------------------------------------------`n" -ForegroundColor DarkGray

        return $true
    } catch {
        Write-Host "`n  [X] FAILED to update persistent.json: $_" -ForegroundColor Red
        return $false
    }
}

# ------------------------------------------------------------------------------
# Language Selection Dialog
# ------------------------------------------------------------------------------
function Prompt-LanguageSelection {
    $langOptions = @(
        [PSCustomObject]@{ Label = (T "LangOptionEN"); Desc = "English interface and map names"; Data = "en" },
        [PSCustomObject]@{ Label = (T "LangOptionTH"); Desc = "เมนูและชื่อแผนที่ภาษาไทย"; Data = "th" },
        [PSCustomObject]@{ Label = (T "LangOptionZH"); Desc = "简体中文菜单与地图名称"; Data = "zh" }
    )

    $choice = Show-InteractiveMenuSimple -Title (T "LangMenuTitle") -Subtitle (T "LangMenuSub") -Items $langOptions
    if ($choice -ge 0) {
        $selectedCode = $langOptions[$choice].Data
        $Script:CurrentLang = $selectedCode
        Save-AppConfig -Language $selectedCode
    }
}

# ------------------------------------------------------------------------------
# Custom Coordinates Dialog
# ------------------------------------------------------------------------------
function Prompt-CustomCoordinates {
    param([string]$Target)

    Clear-ScreenSafely
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  $(T 'CustomDialogTitle')" -ForegroundColor Yellow
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  $(T 'CustomDialogSub')`n" -ForegroundColor DarkGray

    $pidStr = Read-Host "  $(T 'CustomPlanePrompt')"
    if (-not [int]::TryParse($pidStr, [ref]$null)) {
        Write-Host "  $(T 'CustomInvalidPlane')" -ForegroundColor Red
        Start-Sleep -Seconds 2
        return
    }

    $xStr = Read-Host "  $(T 'CustomXPrompt')"
    $yStr = Read-Host "  $(T 'CustomYPrompt')"
    $zStr = Read-Host "  $(T 'CustomZPrompt')"
    $layerStr = Read-Host "  $(T 'CustomLayerPrompt')"

    $x = if ([int]::TryParse($xStr, [ref]$null)) { [int]$xStr } else { 0 }
    $y = if ([int]::TryParse($yStr, [ref]$null)) { [int]$yStr } else { 0 }
    $z = if ([int]::TryParse($zStr, [ref]$null)) { [int]$zStr } else { 0 }
    $layer = if ([int]::TryParse($layerStr, [ref]$null)) { [int]$layerStr } else { 1 }

    $customScene = [PSCustomObject]@{
        name = "Custom Location (Plane $pidStr)"
        name_th = "ตำแหน่งที่กำหนดเอง (Plane $pidStr)"
        name_zh = "自定义位置 (位面 $pidStr)"
        plane_id = [int]$pidStr
        x = $x
        y = $y
        z = $z
        map_layer = $layer
    }

    Apply-SceneTeleport -Target $Target -Scene $customScene -PlanetName "Custom" | Out-Null
    Write-Host "  $(T 'CustomPressAnyKey')" -ForegroundColor DarkGray
    [Console]::ReadKey($true) | Out-Null
}

# ------------------------------------------------------------------------------
# Self-Test Mode
# ------------------------------------------------------------------------------
if ($Test) {
    Write-Host "[TEST] Verifying persistent.json detection..." -ForegroundColor Cyan
    $p = Find-PersistentJson
    if (-not $p) {
        Write-Host "[FAIL] Could not find persistent.json!" -ForegroundColor Red
        exit 1
    }
    Write-Host "[PASS] Found: $p" -ForegroundColor Green

    Write-Host "[TEST] Loading scenes database..." -ForegroundColor Cyan
    $db = Get-ScenesDatabase
    if (-not $db -or $db.Count -eq 0) {
        Write-Host "[FAIL] Could not load scenes database!" -ForegroundColor Red
        exit 1
    }
    Write-Host "[PASS] Loaded $($db.Count) planets successfully!" -ForegroundColor Green

    if ($SelectPlane -gt 0) {
        Write-Host "[TEST] Testing scene teleport to Plane $SelectPlane..." -ForegroundColor Cyan
        $foundSc = $null
        $pName = ""
        foreach ($pl in $db) {
            foreach ($sc in $pl.scenes) {
                if ($sc.plane_id -eq $SelectPlane) {
                    $foundSc = $sc
                    $pName = Get-LocalizedName $pl
                    break
                }
            }
            if ($foundSc) { break }
        }

        if ($foundSc) {
            $ok = Apply-SceneTeleport -Target $p -Scene $foundSc -PlanetName $pName
            if ($ok) {
                Write-Host "[PASS] Applied scene successfully!" -ForegroundColor Green
                exit 0
            } else {
                Write-Host "[FAIL] Failed to apply scene!" -ForegroundColor Red
                exit 1
            }
        }
    }

    Write-Host "[PASS] All self-tests passed!" -ForegroundColor Green
    exit 0
}

# ------------------------------------------------------------------------------
# Main Application Loop
# ------------------------------------------------------------------------------
function Main {
    # 1. Resolve persistent.json
    $persistentPath = Find-PersistentJson
    while (-not $persistentPath) {
        $persistentPath = Prompt-PersistentPath
    }

    # 2. Load Scenes
    $planets = Get-ScenesDatabase
    if (-not $planets) {
        Write-Host "  [!] Failed to load scenes database. Exiting..." -ForegroundColor Red
        pause
        exit 1
    }

    $lastPlanetIdx = 0
    $lastSceneIdx = 0

    while ($true) {
        # Inspect current scene in persistent.json
        $currentInfo = T "UnknownLocation"
        try {
            $currData = (Get-Content -Raw -Encoding UTF8 $persistentPath | ConvertFrom-Json).scene
            $currentPlane = $currData.plane_id
            $foundScene = $null
            foreach ($p in $planets) {
                foreach ($s in $p.scenes) {
                    if ($s.plane_id -eq $currentPlane) {
                        $foundScene = "$(Get-LocalizedName $s) [$(Get-LocalizedName $p)] (Plane: $currentPlane)"
                        break
                    }
                }
                if ($foundScene) { break }
            }
            if ($foundScene) {
                $currentInfo = $foundScene
            } else {
                $currentInfo = "Plane: $currentPlane (X: $($currData.x), Y: $($currData.y), Z: $($currData.z))"
            }
        } catch {}

        # Build Planet Menu Options
        $planetOptions = @()
        for ($i = 0; $i -lt $planets.Count; $i++) {
            $p = $planets[$i]
            $pName = Get-LocalizedName $p
            $planetOptions += [PSCustomObject]@{
                Label = "$($p.icon) $pName  ($(T 'MapCount' @($p.scenes.Count)))"
                Desc = (T 'MapCount' @($p.scenes.Count))
                Data = $p
            }
        }
        $planetOptions += [PSCustomObject]@{ Label = (T "ActionCustom"); Desc = (T "ActionCustomDesc"); Data = "custom" }
        $planetOptions += [PSCustomObject]@{ Label = (T "ActionLang"); Desc = (T "ActionLangDesc"); Data = "lang" }
        $planetOptions += [PSCustomObject]@{ Label = (T "ActionRepath"); Desc = "$persistentPath"; Data = "repath" }
        $planetOptions += [PSCustomObject]@{ Label = (T "ActionExit"); Desc = (T "ActionExitDesc"); Data = "exit" }

        $subtitle = "$(T 'ActiveLabel')$currentInfo`n  $(T 'TargetLabel')$persistentPath"
        $chosenPlanetIdx = Show-InteractiveMenu -Title (T "AppTitle") -Subtitle $subtitle -Items $planetOptions -InitialIndex $lastPlanetIdx

        if ($chosenPlanetIdx -lt 0) {
            # User pressed ESC
            break
        }
        $lastPlanetIdx = $chosenPlanetIdx
        $chosenItem = $planetOptions[$chosenPlanetIdx]

        if ($chosenItem.Data -eq "exit") {
            break
        }
        elseif ($chosenItem.Data -eq "lang") {
            Prompt-LanguageSelection
            continue
        }
        elseif ($chosenItem.Data -eq "custom") {
            Prompt-CustomCoordinates -Target $persistentPath
            continue
        }
        elseif ($chosenItem.Data -eq "repath") {
            $newPath = Prompt-PersistentPath
            if ($newPath) { $persistentPath = $newPath }
            continue
        }

        # Selected Planet -> Show Scenes Submenu
        $selectedPlanet = $chosenItem.Data
        $selectedPlanetName = Get-LocalizedName $selectedPlanet
        while ($true) {
            $sceneOptions = @()
            for ($s = 0; $s -lt $selectedPlanet.scenes.Count; $s++) {
                $sc = $selectedPlanet.scenes[$s]
                $scName = Get-LocalizedName $sc
                $scDesc = Get-LocalizedDesc $sc
                $sceneOptions += [PSCustomObject]@{
                    Label = "$($s + 1). [Plane $($sc.plane_id)] $scName"
                    Desc = $scDesc
                    Data = $sc
                }
            }
            $sceneOptions += [PSCustomObject]@{ Label = (T "ActionBack"); Desc = (T "ActionBackDesc"); Data = "back" }

            $sceneSub = "$(T 'SummaryPlanet')$selectedPlanetName`n  $(T 'Controls')"
            $chosenSceneIdx = Show-InteractiveMenu -Title "$($selectedPlanet.icon) $selectedPlanetName" -Subtitle $sceneSub -Items $sceneOptions -InitialIndex $lastSceneIdx

            if ($chosenSceneIdx -lt 0) {
                # ESC pressed -> back to planets
                break
            }
            $lastSceneIdx = $chosenSceneIdx
            $chosenSceneItem = $sceneOptions[$chosenSceneIdx]

            if ($chosenSceneItem.Data -eq "back") {
                break
            }

            # Apply Scene Selection!
            $selectedScene = $chosenSceneItem.Data
            $applied = Apply-SceneTeleport -Target $persistentPath -Scene $selectedScene -PlanetName $selectedPlanetName

            # Action menu after applying
            if ($applied) {
                Write-Host "  $(T 'NextPrompt')" -ForegroundColor Yellow
                Write-Host "  $(T 'NextOption1')" -ForegroundColor Cyan
                
                # Check if ppsr.exe exists in directory or relative to persistent.json
                $persistentDir = Split-Path -Parent $persistentPath
                $ppsrExeCandidates = @(
                    (Join-Path $ScriptDir "ppsr.exe"),
                    (Join-Path $ScriptDir "..\ppsr.exe"),
                    (Join-Path $persistentDir "..\ppsr.exe"),
                    (Join-Path $persistentDir "ppsr.exe")
                )
                $ppsrExe = $null
                foreach ($cand in $ppsrExeCandidates) {
                    if (Test-Path $cand) { $ppsrExe = (Resolve-Path $cand).Path; break }
                }
                if (-not $ppsrExe) {
                    $uProf = [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
                    if ($uProf) {
                        $foundExe = Get-ChildItem -Path (Join-Path $uProf "Downloads") -Filter "ppsr.exe" -Recurse -Depth 4 -ErrorAction SilentlyContinue | Select-Object -First 1
                        if ($foundExe) { $ppsrExe = $foundExe.FullName }
                    }
                }

                if ($ppsrExe) {
                    Write-Host "  $(T 'NextOption2Server')" -ForegroundColor Green
                    Write-Host "  $(T 'NextOption3Exit')" -ForegroundColor Gray
                    Write-Host ""
                    $choice = Read-Host "  $(T 'NextSelectPrompt' @('1-3'))"
                    if ($choice -eq "2") {
                        Write-Host "`n  $(T 'CheckingServer')" -ForegroundColor Yellow
                        Get-Process -Name "ppsr" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                        Start-Sleep -Milliseconds 600

                        $ppsrDir = Split-Path -Parent $ppsrExe
                        Write-Host "  $(T 'LaunchingServer')" -ForegroundColor Green
                        
                        $cmdArgs = "/k title ppSR Server & chcp 65001 >nul & set PYTHONIOENCODING=utf-8 & cd /d `"$ppsrDir`" & `"$ppsrExe`""
                        Start-Process -FilePath "cmd.exe" -ArgumentList $cmdArgs -WorkingDirectory $ppsrDir
                        Start-Sleep -Seconds 1
                        exit 0
                    }
                    elseif ($choice -eq "3") {
                        exit 0
                    }
                } else {
                    Write-Host "  $(T 'NextOption2Exit')" -ForegroundColor Gray
                    Write-Host ""
                    $choice = Read-Host "  $(T 'NextSelectPrompt' @('1-2'))"
                    if ($choice -eq "2") {
                        exit 0
                    }
                }
            }
            break
        }
    }

    Clear-ScreenSafely
    Write-Host "`n  $(T 'Goodbye')`n" -ForegroundColor Cyan
}

Main
