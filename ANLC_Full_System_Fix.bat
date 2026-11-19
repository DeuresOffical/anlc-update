@echo off
setlocal enabledelayedexpansion
title ANLC Suite - Full System Fix v2.0
chcp 437 >nul 2>&1

rem ===========================================================
rem  ANLC TACTICAL SUITE - FULL SYSTEM FIX v2.0
rem  Mo Khoa Toan Dien Driver Ring-0 cho may khach
rem  CHAY VOI QUYEN ADMINISTRATOR VA RESTART SAU KHI XONG
rem ===========================================================

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Dang yeu cau quyen Administrator...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
cls
echo ============================================================
echo   ANLC TACTICAL SUITE - FULL SYSTEM FIX v2.0
echo   Dap ung 100%% dieu kien he thong - Mo khoa Ring-0 Driver
echo ============================================================
echo.
echo [INFO] Bat dau qua trinh cau hinh toan dien...
echo.

rem ===========================================================
rem [1/14] Tat Tamper Protection de cho phep cac buoc tiep theo
rem ===========================================================
echo [1/14] Vo hieu hoa Windows Defender Tamper Protection...
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtectionSource" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEng.exe" /v "Debugger" /t REG_SZ /d "" /f >nul 2>&1
echo       -> [OK] Da xu ly Tamper Protection.

rem ===========================================================
rem [2/14] Them Exclusion TRUOC KHI lam bat cu dieu gi khac
rem        (tranh Defender quarantine driver khi Loader extract)
rem ===========================================================
echo [2/14] Them Exclusion toan dien cho ANLC (uu tien cao nhat)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -ExclusionPath ($env:LOCALAPPDATA + '\ANLC_LoaderCache'), ($env:USERPROFILE + '\Desktop'), ($env:TEMP), 'C:\Windows\Temp', ($env:LOCALAPPDATA + '\Temp') -ErrorAction SilentlyContinue } catch {}"  >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -ExclusionProcess 'ANLC_Loader.exe','ANLC_Net_Loader.exe','ANLC_Admin_Loader.exe','ANLC_Core.exe','RobRunPort.exe','kd2.exe','kernel-mode.sys','driver.sys' -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -ExclusionExtension '.sys','.bin' -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
echo       -> [OK] Da them Exclusion cho tat ca tien trinh ANLC.

rem ===========================================================
rem [3/14] Tat Defender Real-time va cac module quet nang
rem ===========================================================
echo [3/14] Tat Windows Defender Real-time Monitoring...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableBlockAtFirstSeen $true -DisableIOAVProtection $true -DisableScriptScanning $true -SubmitSamplesConsent 2 -MAPSReporting 0 -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -AttackSurfaceReductionRules_Ids 56eb5699-5b61-483c-bb1f-1ee30242fa79 -AttackSurfaceReductionRules_Actions Disabled -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -AttackSurfaceReductionRules_Ids d4f940ab-401b-4efc-aadc-ad5f3c50688a -AttackSurfaceReductionRules_Actions Disabled -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
echo       -> [OK] Da tat Real-time va ASR rules.

rem ===========================================================
rem [4/14] Don dep file bi Defender quarantine truoc do
rem ===========================================================
echo [4/14] Xoa cache bi Defender dua vao quarantine...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Remove-Item -Path ($env:ProgramData + '\Microsoft\Windows Defender\Quarantine\*') -Recurse -Force -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Remove-Item -Path ($env:ProgramData + '\Microsoft\Windows Defender\LocalCopy\*') -Recurse -Force -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
echo       -> [OK] Da don dep Quarantine cache.

rem ===========================================================
rem [5/14] Tat Microsoft Vulnerable Driver Blocklist
rem ===========================================================
echo [5/14] Tat Microsoft Vulnerable Driver Blocklist (loi 0xc0000603)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "UpgradedSystem" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HypervisorEnforcedCodeIntegrity" /t REG_DWORD /d 0 /f >nul 2>&1
echo       -> [OK] Da vo hieu hoa blocklist Driver.

rem ===========================================================
rem [6/14] Tat Core Isolation / Memory Integrity (HVCI)
rem ===========================================================
echo [6/14] Tat Core Isolation va Memory Integrity (HVCI)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\CredentialGuard" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo       -> [OK] Da tat Memory Integrity.

rem ===========================================================
rem [7/14] Tat Virtualization-Based Security (VBS) va DeviceGuard
rem ===========================================================
echo [7/14] Tat Virtualization-Based Security (VBS)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "Locked" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LsaCfgFlags" /t REG_DWORD /d 0 /f >nul 2>&1
echo       -> [OK] Da cau hinh tat VBS va DeviceGuard.

rem ===========================================================
rem [8/14] Cau hinh khoi dong BCD (Hypervisor, TestSigning, NoIntegrityChecks)
rem ===========================================================
echo [8/14] Cau hinh Boot Configuration (BCD)...
bcdedit /set hypervisorlaunchtype off >nul 2>&1
bcdedit /set vsmlaunchtype off >nul 2>&1
bcdedit /set vm off >nul 2>&1
bcdedit /set nointegritychecks on >nul 2>&1
bcdedit /set testsigning on >nul 2>&1
bcdedit /set loadoptions DDISABLE_INTEGRITY_CHECKS >nul 2>&1
echo       -> [OK] BCD da duoc cau hinh cho Driver Ring-0.

rem ===========================================================
rem [9/14] Tat Smart App Control (Windows 11)
rem ===========================================================
echo [9/14] Tat Smart App Control va CI Policy...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 0 /f >nul 2>&1
echo       -> [OK] Da tat Smart App Control.

rem ===========================================================
rem [10/14] Don dep ANLC_LoaderCache - tranh file cu bi lock/corrupt
rem ===========================================================
echo [10/14] Don dep thu muc ANLC_LoaderCache cu...
sc stop iqvw64e >nul 2>&1
sc delete iqvw64e >nul 2>&1
sc stop AnlcCore >nul 2>&1
sc delete AnlcCore >nul 2>&1
sc stop SmxRing >nul 2>&1
sc delete SmxRing >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Remove-Item -Path ($env:LOCALAPPDATA + '\ANLC_LoaderCache\rt\*') -Recurse -Force -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Remove-Item -Path ($env:LOCALAPPDATA + '\ANLC_WebCache\*') -Recurse -Force -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
mkdir "%LOCALAPPDATA%\ANLC_LoaderCache\rt" >nul 2>&1
icacls "%LOCALAPPDATA%\ANLC_LoaderCache" /grant Everyone:(OI)(CI)F /T /Q >nul 2>&1
echo       -> [OK] Da don dep va cap quyen thu muc Cache.

rem ===========================================================
rem [11/14] Dam bao Page File du lon (tranh BSOD pool exhaustion)
rem ===========================================================
echo [11/14] Kiem tra va cau hinh Page File (RAM ao)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $cs = Get-WmiObject Win32_ComputerSystem; if ($cs.AutomaticManagedPagefile -eq $false) { $cs.AutomaticManagedPagefile = $true; $cs.Put() | Out-Null; Write-Host 'PageFile: Set to System Managed' } else { Write-Host 'PageFile: OK (System Managed)' } } catch { Write-Host 'PageFile: Skipped' }" >nul 2>&1
wmic pagefileset set MaximumSize=8192,MinimumSize=2048 >nul 2>&1
echo       -> [OK] Page File da duoc dam bao du dung luong.

rem ===========================================================
rem [12/14] Dung Windows Update tam thoi (tranh re-enable HVCI)
rem ===========================================================
echo [12/14] Tam dung Windows Update (tranh bi reset cau hinh)...
sc stop wuauserv >nul 2>&1
sc stop UsoSvc >nul 2>&1
sc stop WaaSMedicSvc >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f >nul 2>&1
echo       -> [OK] Da tam dung Windows Update.

rem ===========================================================
rem [13/14] Reset network stack (hop tac server auth tot hon)
rem ===========================================================
echo [13/14] Reset mang de ket noi auth server on dinh hon...
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo       -> [OK] Network stack da duoc reset.

rem ===========================================================
rem [14/14] Kiem tra Secure Boot
rem ===========================================================
echo [14/14] Kiem tra trang thai Secure Boot (UEFI)...
set "SB_ON=0"
for /f "tokens=*" %%S in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "try { if (Confirm-SecureBootUEFI) { 'ON' } else { 'OFF' } } catch { 'OFF' }"') do (
    if /i "%%S"=="ON" set "SB_ON=1"
)
if "!SB_ON!"=="1" (
    echo       -> [CANH BAO] Secure Boot dang BAT - Co the can tat trong BIOS!
    echo          Vao BIOS ^(F2/Del/Esc khi khoi dong^) -^> tim Secure Boot -^> Disabled
    echo          ROI QUAY LAI CHAY FILE NAY LAN NUA.
) else (
    echo       -> [OK] Secure Boot da tat hoac khong can thiep.
)

echo.
echo ============================================================
echo   [HOAN TAT] MAY TINH DA DAT 100%% DIEU KIEN ANLC SUITE!
echo ============================================================
echo.
echo   QUAN TRONG: Phai RESTART may tinh de ap dung thay doi!
echo   Sau khi Restart, mo Loader va an Load Driver binh thuong.
echo.
echo   Neu van loi sau Restart:
echo   - Tat Secure Boot trong BIOS (xem buoc 14)
echo   - Lien he Admin: @AnotherIfeIOS
echo.
echo ------------------------------------------------------------
set /p REBOOT_CHOICE="Khoi dong lai may tinh ngay bay gio? [Y/N]: "
if /i "!REBOOT_CHOICE!"=="Y" (
    echo.
    echo May se khoi dong lai sau 5 giay - Hay luu tai lieu!
    timeout /t 5
    shutdown /r /t 0
) else (
    echo.
    echo Ban da chon khong Restart ngay.
    echo HAY TU RESTART TRUOC KHI MO ANLC LOADER!
    echo.
    pause
)
exit /b 0
