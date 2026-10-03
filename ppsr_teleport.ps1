# ==============================================================================
#  ppSR Scene & Map Teleporter Manager
#  Compatible with ppSR (Project Star Rail / 4.4.x - 4.6.x+)
# ==============================================================================

param(
    [switch]$Test,
    [string]$TargetFile = "",
    [int]$SelectPlane = 0
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $ScriptDir) { $ScriptDir = $PWD.Path }

$ConfigPath = Join-Path $ScriptDir "ppsr_config.json"
$ScenesPath = Join-Path $ScriptDir "scenes.json"

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

function Save-PersistentConfig {
    param([string]$Path)
    $obj = @{ persistent_path = $Path }
    $json = $obj | ConvertTo-Json
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ConfigPath, $json, $utf8NoBom)
}

function Prompt-PersistentPath {
    Clear-Host
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
                Save-PersistentConfig $subPath
                return (Resolve-Path $subPath).Path
            }
            $subPath2 = Join-Path $inputPath "persistent.json"
            if (Test-Path $subPath2) {
                Save-PersistentConfig $subPath2
                return (Resolve-Path $subPath2).Path
            }
        } else {
            Save-PersistentConfig $inputPath
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
        $parsed = $raw | ConvertFrom-Json
        return $parsed.planets
    } catch {
        Write-Host "  [!] Error parsing scenes.json: $_" -ForegroundColor Red
        return $null
    }
}

# ------------------------------------------------------------------------------
# Interactive Menu Engine (Arrow keys, flicker-free)
# ------------------------------------------------------------------------------
function Show-InteractiveMenu {
    param(
        [string]$Title,
        [string]$Subtitle,
        [array]$Items,
        [int]$PageSize = 12,
        [int]$InitialIndex = 0
    )

    if (-not $Items -or $Items.Count -eq 0) { return -1 }

    $sel = [Math]::Max(0, [Math]::Min($InitialIndex, $Items.Count - 1))
    $topVisible = 0

    Clear-Host
    Write-Host "================================================================================" -ForegroundColor DarkCyan
    Write-Host "  $Title" -ForegroundColor Cyan
    if ($Subtitle) {
        Write-Host "  $Subtitle" -ForegroundColor DarkGray
    }
    Write-Host "================================================================================" -ForegroundColor DarkCyan
    Write-Host "  Controls: [UP/DOWN] Navigate  |  [ENTER] Select  |  [ESC] Go Back" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkGray

    $startRow = [Console]::CursorTop
    [Console]::CursorVisible = $false

    try {
        while ($true) {
            if ($sel -lt $topVisible) {
                $topVisible = $sel
            }
            elseif ($sel -ge ($topVisible + $PageSize)) {
                $topVisible = $sel - $PageSize + 1
            }

            [Console]::SetCursorPosition(0, $startRow)

            if ($topVisible -gt 0) {
                Write-Host "     ^^^  (More items above...)" -ForegroundColor DarkYellow
            } else {
                Write-Host "                                   "
            }

            $limit = [Math]::Min($Items.Count, $topVisible + $PageSize)
            for ($i = $topVisible; $i -lt $limit; $i++) {
                $it = $Items[$i]
                $label = $it.Label
                $desc = $it.Desc

                $paddedLabel = $label.PadRight(44)
                if ($i -eq $sel) {
                    Write-Host "  > " -NoNewline -ForegroundColor Green
                    Write-Host " $paddedLabel " -NoNewline -ForegroundColor Black -BackgroundColor Green
                    if ($desc) {
                        Write-Host "  $desc" -ForegroundColor DarkGreen
                    } else {
                        Write-Host ""
                    }
                } else {
                    Write-Host "    $paddedLabel" -NoNewline -ForegroundColor Gray
                    if ($desc) {
                        Write-Host "  $desc" -ForegroundColor DarkGray
                    } else {
                        Write-Host ""
                    }
                }
            }

            $rendered = $limit - $topVisible
            for ($k = $rendered; $k -lt $PageSize; $k++) {
                Write-Host (" " * 80)
            }

            if ($limit -lt $Items.Count) {
                Write-Host "     vvv  (More items below...)" -ForegroundColor DarkYellow
            } else {
                Write-Host "                                   "
            }

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
        [Console]::CursorVisible = $true
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

    Clear-Host
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  Applying Teleport Configuration" -ForegroundColor Yellow
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
        Write-Host "`n  [OK] SUCCESS: persistent.json has been updated!" -ForegroundColor Green
        Write-Host "  ----------------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host "  Planet:        " -NoNewline -ForegroundColor White; Write-Host $PlanetName -ForegroundColor Yellow
        Write-Host "  Scene Name:    " -NoNewline -ForegroundColor White; Write-Host $Scene.name -ForegroundColor Cyan
        Write-Host "  Plane ID:      " -NoNewline -ForegroundColor White; Write-Host $planeId -ForegroundColor Magenta
        Write-Host "  Coordinates:   " -NoNewline -ForegroundColor White; Write-Host "X: $x | Y: $y | Z: $z" -ForegroundColor Green
        Write-Host "  Map Layer:     " -NoNewline -ForegroundColor White; Write-Host $mapLayer -ForegroundColor DarkCyan
        Write-Host "  Calyx Spawn:   " -NoNewline -ForegroundColor White; Write-Host "X: $calyxX | Y: $calyxY | Z: $calyxZ (Prop: $calyxPropId)" -ForegroundColor DarkYellow
        Write-Host "  Target File:   " -NoNewline -ForegroundColor White; Write-Host $Target -ForegroundColor DarkGray
        Write-Host "  Backup File:   " -NoNewline -ForegroundColor White; Write-Host $bakPath -ForegroundColor DarkGray
        Write-Host "  ----------------------------------------------------------------`n" -ForegroundColor DarkGray

        return $true
    } catch {
        Write-Host "`n  [X] FAILED to update persistent.json: $_" -ForegroundColor Red
        return $false
    }
}

# ------------------------------------------------------------------------------
# Custom Coordinates Dialog
# ------------------------------------------------------------------------------
function Prompt-CustomCoordinates {
    param([string]$Target)

    Clear-Host
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  [+] Enter Custom Scene / Plane Coordinates" -ForegroundColor Yellow
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  Type your custom plane ID and spawn coordinates:`n" -ForegroundColor DarkGray

    $pidStr = Read-Host "  Enter Plane ID (e.g. 20313)"
    if (-not [int]::TryParse($pidStr, [ref]$null)) {
        Write-Host "  [!] Invalid Plane ID. Operation cancelled." -ForegroundColor Red
        Start-Sleep -Seconds 2
        return
    }

    $xStr = Read-Host "  Enter Coordinate X (e.g. 40748)"
    $yStr = Read-Host "  Enter Coordinate Y (e.g. 192819)"
    $zStr = Read-Host "  Enter Coordinate Z (e.g. 439218)"
    $layerStr = Read-Host "  Enter Map Layer (Default: 1, Press Enter to skip)"

    $x = if ([int]::TryParse($xStr, [ref]$null)) { [int]$xStr } else { 0 }
    $y = if ([int]::TryParse($yStr, [ref]$null)) { [int]$yStr } else { 0 }
    $z = if ([int]::TryParse($zStr, [ref]$null)) { [int]$zStr } else { 0 }
    $layer = if ([int]::TryParse($layerStr, [ref]$null)) { [int]$layerStr } else { 1 }

    $customScene = [PSCustomObject]@{
        name = "Custom Location (Plane $pidStr)"
        plane_id = [int]$pidStr
        x = $x
        y = $y
        z = $z
        map_layer = $layer
    }

    Apply-SceneTeleport -Target $Target -Scene $customScene -PlanetName "Custom / Manual" | Out-Null
    Write-Host "  Press any key to return to menu..." -ForegroundColor DarkGray
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
                    $pName = $pl.name
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
        $currentInfo = "Unknown"
        try {
            $currData = (Get-Content -Raw -Encoding UTF8 $persistentPath | ConvertFrom-Json).scene
            $currentPlane = $currData.plane_id
            $foundScene = $null
            foreach ($p in $planets) {
                foreach ($s in $p.scenes) {
                    if ($s.plane_id -eq $currentPlane) {
                        $foundScene = "$($s.name) [$($p.name)] (Plane: $currentPlane)"
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
            $planetOptions += [PSCustomObject]@{
                Label = "$($p.icon) $($p.name)"
                Desc = "$($p.scenes.Count) available maps"
                Data = $p
            }
        }
        $planetOptions += [PSCustomObject]@{ Label = "[+] Custom Coordinates"; Desc = "Enter Plane ID and X,Y,Z manually"; Data = "custom" }
        $planetOptions += [PSCustomObject]@{ Label = "[*] Change persistent.json Path"; Desc = "Target: $persistentPath"; Data = "repath" }
        $planetOptions += [PSCustomObject]@{ Label = "[x] Exit"; Desc = "Close application"; Data = "exit" }

        $subtitle = "Active: $currentInfo`n  Target: $persistentPath"
        $chosenPlanetIdx = Show-InteractiveMenu -Title "Escape Penacony Tool - Scene and Map Teleporter" -Subtitle $subtitle -Items $planetOptions -InitialIndex $lastPlanetIdx

        if ($chosenPlanetIdx -lt 0) {
            # User pressed ESC
            break
        }
        $lastPlanetIdx = $chosenPlanetIdx
        $chosenItem = $planetOptions[$chosenPlanetIdx]

        if ($chosenItem.Data -eq "exit") {
            break
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
        while ($true) {
            $sceneOptions = @()
            for ($s = 0; $s -lt $selectedPlanet.scenes.Count; $s++) {
                $sc = $selectedPlanet.scenes[$s]
                $sceneOptions += [PSCustomObject]@{
                    Label = "$($s + 1). $($sc.name)"
                    Desc = "[Plane: $($sc.plane_id)] $($sc.desc)"
                    Data = $sc
                }
            }
            $sceneOptions += [PSCustomObject]@{ Label = "[<-] Back to Planet Selection"; Desc = ""; Data = "back" }

            $sceneSub = "Planet: $($selectedPlanet.name)`n  Select destination scene to update persistent.json:"
            $chosenSceneIdx = Show-InteractiveMenu -Title "$($selectedPlanet.icon) $($selectedPlanet.name) - Select Map" -Subtitle $sceneSub -Items $sceneOptions -InitialIndex $lastSceneIdx

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
            $applied = Apply-SceneTeleport -Target $persistentPath -Scene $selectedScene -PlanetName $selectedPlanet.name

            # Action menu after applying
            if ($applied) {
                Write-Host "  What would you like to do next?" -ForegroundColor Yellow
                Write-Host "  [1] Teleport to another scene" -ForegroundColor Cyan
                
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
                    Write-Host "  [2] Restart & Launch ppSR Server (ppsr.exe)" -ForegroundColor Green
                    Write-Host "  [3] Exit" -ForegroundColor Gray
                    Write-Host ""
                    $choice = Read-Host "  Select option (1-3, Default: 1)"
                    if ($choice -eq "2") {
                        Write-Host "`n  [*] Checking running ppSR server..." -ForegroundColor Yellow
                        # Gracefully terminate any previous ppsr process to avoid port 21000/23301 conflicts
                        Get-Process -Name "ppsr" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                        Start-Sleep -Milliseconds 600

                        $ppsrDir = Split-Path -Parent $ppsrExe
                        Write-Host "  [*] Launching ppSR Server in dedicated UTF-8 console window..." -ForegroundColor Green
                        
                        # Use cmd.exe /k with chcp 65001 and PYTHONIOENCODING=utf-8 so it never crashes on Chinese text or closes on error
                        $cmdArgs = "/k title ppSR Server & chcp 65001 >nul & set PYTHONIOENCODING=utf-8 & cd /d `"$ppsrDir`" & `"$ppsrExe`""
                        Start-Process -FilePath "cmd.exe" -ArgumentList $cmdArgs -WorkingDirectory $ppsrDir
                        Start-Sleep -Seconds 1
                        exit 0
                    }
                    elseif ($choice -eq "3") {
                        exit 0
                    }
                } else {
                    Write-Host "  [2] Exit" -ForegroundColor Gray
                    Write-Host ""
                    $choice = Read-Host "  Select option (1-2, Default: 1)"
                    if ($choice -eq "2") {
                        exit 0
                    }
                }
            }
            break
        }
    }

    Clear-Host
    Write-Host "`n  Thank you for using ppSR Scene and Map Teleporter! Goodbye.`n" -ForegroundColor Cyan
}

Main
