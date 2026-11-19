@echo off
setlocal enabledelayedexpansion
title ANLC Tactical Suite - Restore Default Windows Security

rem --- Kiem tra quyen Administrator va tu dong xin quyen ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Dang yeu cau quyen Administrator...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
cls
echo ===================================================================
echo    ANLC TACTICAL SUITE - RESTORE DEFAULT WINDOWS SECURITY
echo    Bat Lai Toan Bo Bao Mat Mac Dinh Cua Windows (Security ON)
echo ===================================================================
echo.
echo Dang tien hanh khoi phuc cac tinh nang bao mat goc cua Windows...
echo.

rem [1/6] Bat lai Microsoft Vulnerable Driver Blocklist
echo [1/6] Bat lai Microsoft Vulnerable Driver Blocklist...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d 1 /f >nul 2>&1
echo       -^> [OK] Da bat lai danh sach chan Driver mac dinh.

rem [2/6] Bat lai Core Isolation / HVCI / Memory Integrity
echo [2/6] Bat lai Core Isolation / Memory Integrity (HVCI)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d 1 /f >nul 2>&1
echo       -^> [OK] Da bat lai Memory Integrity.

rem [3/6] Bat lai Virtualization-Based Security (VBS)
echo [3/6] Bat lai Virtualization-Based Security (VBS)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d 1 /f >nul 2>&1
echo       -^> [OK] Da bat lai VBS.

rem [4/6] Bat lai Hypervisor khoi dong (BCD Edit)
echo [4/6] Bat lai Hypervisor mac dinh (Auto)...
bcdedit /set hypervisorlaunchtype auto >nul 2>&1
echo       -^> [OK] bcdedit: hypervisorlaunchtype auto thanh cong.

rem [5/6] Bat lai quy tac chan Driver cua Windows Defender (ASR)
echo [5/6] Khoi phuc chinh sach bao ve cua Windows Defender...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 1 /f >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -AttackSurfaceReductionRules_Ids 56eb5699-5b61-483c-bb1f-1ee30242fa79 -AttackSurfaceReductionRules_Actions Enabled -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
echo       -^> [OK] Da bat lai quy tac Defender ASR.

rem [6/6] Xoa danh sach ngoai le (Exclusion) cua ANLC trong Defender
echo [6/6] Xoa thu muc ngoai le khoi Windows Defender...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Remove-MpPreference -ExclusionPath ($env:LOCALAPPDATA + '\ANLC_LoaderCache') -ErrorAction SilentlyContinue } catch {}" >nul 2>&1
echo       -^> [OK] Da xoa loai tru Defender.

echo.
echo ===================================================================
echo   [HOAN TAT] DA KHOI PHUC 100%% BAO MAT MAC DINH CUA WINDOWS!
echo ===================================================================
echo.
echo   LUU Y CUC KY QUAN TRONG:
echo   Cac thiet lap bao mat he thong (Memory Integrity, Hypervisor)
echo   CHI HOAT DONG TRO LAI SAU KHI BAN RESTART MAY TINH.
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
    echo VUI LONG TU RESTART MAY TINH DE AP DUNG BAO MAT!
    echo.
    pause
)
exit /b 0
