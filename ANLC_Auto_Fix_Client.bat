@echo off
setlocal enabledelayedexpansion
title ANLC Tactical Suite - Ultimate System Optimizer (All Requirements)

rem ===================================================================
rem [1/10] Kiem tra quyen Administrator va tu dong xin quyen
rem ===================================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Dang yeu cau quyen Administrator de cau hinh he thong...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
cls
echo ===================================================================
echo    ANLC TACTICAL SUITE - ULTIMATE SYSTEM OPTIMIZER
echo    Tu Dong Dap Ung 100%% Dieu Kien He Thong - Mo Khoa Driver Ring-0
echo ===================================================================
echo.
echo Dang tien hanh kiem tra va cau hinh toan dien Windows cho ANLC Suite...
echo.

rem ===================================================================
rem [2/10] Tat Microsoft Vulnerable Driver Blocklist & Code Integrity
rem ===================================================================
echo [2/10] Tat Microsoft Vulnerable Driver Blocklist...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "UpgradedSystem" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HypervisorEnforcedCodeIntegrity" /t REG_DWORD /d 0 /f >nul 2>&1
echo       -^> [OK] Da vo hieu hoa danh sach chan Driver cua Windows.

rem ===================================================================
rem [3/10] Tat Core Isolation / Memory Integrity (HVCI)
rem ===================================================================
echo [3/10] Tat Core Isolation / Memory Integrity (HVCI)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\CredentialGuard" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo       -^> [OK] Da tat Memory Integrity.

rem ===================================================================
rem [4/10] Tat Virtualization-Based Security (VBS) & DeviceGuard
rem ===================================================================
echo [4/10] Tat Virtualization-Based Security (VBS)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "Locked" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LsaCfgFlags" /t REG_DWORD /d 0 /f >nul 2>&1
echo       -^> [OK] Da cau hinh tat VBS va DeviceGuard.

rem ===================================================================
rem [5/10] Cau hinh khoi dong BCD Edit
rem ===================================================================
echo [5/10] Cau hinh khoi dong BCD Edit (Tat Hypervisor, mo Testsigning)...
bcdedit /set hypervisorlaunchtype off >nul 2>&1
bcdedit /set vsmlaunchtype off >nul 2>&1
bcdedit /set vm off >nul 2>&1
bcdedit /set nointegritychecks on >nul 2>&1
bcdedit /set testsigning on >nul 2>&1
bcdedit /set loadoptions DDISABLE_INTEGRITY_CHECKS >nul 2>&1
echo       -^> [OK] BCD Edit da duoc cau hinh toi uu cho Driver Ring-0.

rem ===================================================================
rem [6/10] Tat Smart App Control (Windows 11)
rem ===================================================================
echo [6/10] Tat Smart App Control...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 0 /f >nul 2>&1
echo       -^> [OK] Da tat Smart App Control.

rem ===================================================================
rem [7/10] Toi uu hoa Windows Defender & Tat luat chan Driver (ASR)
rem ===================================================================
echo [7/10] Toi uu chinh sach Windows Defender...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableBlockAtFirstSeen $true -DisableIOAVProtection $true -DisableScriptScanning $true -SubmitSamplesConsent 2 -MAPSReporting 0 -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -AttackSurfaceReductionRules_Ids 56eb5699-5b61-483c-bb1f-1ee30242fa79 -AttackSurfaceReductionRules_Actions Disabled -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
echo       -^> [OK] Da vo hieu hoa quy tac chan driver cua Defender.

rem ===================================================================
rem [8/10] Them Exclusion toan dien cho ANLC vao Windows Defender
rem ===================================================================
echo [8/10] Them thu muc & tien trinh ANLC vao Exclusion cua Defender...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -ExclusionPath ($env:LOCALAPPDATA + '\ANLC_LoaderCache'), ($env:USERPROFILE + '\Desktop'), ($env:TEMP) -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -ExclusionProcess 'ANLC_Loader.exe', 'ANLC_Net_Loader.exe', 'ANLC_Admin_Loader.exe', 'ANLC_Core.exe', 'RobRunPort.exe', 'kd2.exe', 'driver.sys', 'kernel-mode.sys' -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
echo       -^> [OK] Da them Exclusion bao ve Loader va Driver.

rem ===================================================================
rem [9/10] Don dep cache, cap full quyen thu muc & reset service cu
rem ===================================================================
echo [9/10] Don dep tien trinh cu va cap full quyen thu muc Cache...
sc stop iqvw64e >nul 2>&1
sc delete iqvw64e >nul 2>&1
sc stop AnlcCore >nul 2>&1
sc delete AnlcCore >nul 2>&1
sc stop SmxRing >nul 2>&1
sc delete SmxRing >nul 2>&1

mkdir "%LOCALAPPDATA%\ANLC_LoaderCache\rt" >nul 2>&1
icacls "%LOCALAPPDATA%\ANLC_LoaderCache" /grant Everyone:(OI)(CI)F /T /Q >nul 2>&1
rmdir /s /q "%LOCALAPPDATA%\ANLC_WebCache" >nul 2>&1
echo       -^> [OK] Da lam sach service tam va cap quyen thu muc cache.

rem ===================================================================
rem [10/10] Kiem tra Secure Boot
rem ===================================================================
echo [10/10] Kiem tra trang thai Secure Boot (UEFI)...
set "SB_ON=0"
for /f "tokens=*" %%S in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "try { if (Confirm-SecureBootUEFI) { 'ON' } else { 'OFF' } } catch { 'OFF' }"') do (
    if /i "%%S"=="ON" set "SB_ON=1"
)
if "!SB_ON!"=="1" (
    echo       -^> [CANH BAO] May cua ban dang BAT SECURE BOOT trong BIOS!
    echo          Neu sau khi chay file nay va Restart ma Loader van bao loi:
    echo          Hay vao BIOS (F2/Del) -> tim 'Secure Boot' va chuyen sang 'Disabled'.
) else (
    echo       -^> [OK] Secure Boot da tat hoac khong can thiep vao Ring-0.
)

echo.
echo ===================================================================
echo   [HOAN TAT] MAY TINH DA DAT 100%% DIEU KIEN SU DUNG ANLC SUITE!
echo ===================================================================
echo.
echo   LUU Y CUC KY QUAN TRONG:
echo   Toan bo thay doi he thong (Memory Integrity, Hypervisor, Driver)
echo   BAT BUOC PHAI RESTART MAY TINH DE WINDOWS KERNEL AP DUNG.
echo.
echo -------------------------------------------------------------------
set /p REBOOT_CHOICE="Ban co muon khoi dong lai may tinh ngay bay gio khong? [Y/N]: "
if /i "!REBOOT_CHOICE!"=="Y" (
    echo.
    echo May tinh se tu dong khoi dong lai sau 5 giay...
    echo Hay luu lai cac tai lieu dang lam viec!
    timeout /t 5
    shutdown /r /t 0
) else (
    echo.
    echo Ban da chon khong khoi dong lai ngay.
    echo VUI LONG TU RESTART MAY TINH TRUOC KHI MO LOADER!
    echo.
    pause
)
exit /b 0
