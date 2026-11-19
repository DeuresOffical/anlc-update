@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   ANLC CLOUD AUTO-UPDATE PUBLISHER (DeuresOffical/anlc-update)
echo ============================================================
echo.
echo Phien ban hien tai trong anlc_update.json:
type anlc_update.json
echo.
set /p NEW_VER="Nhap so phien ban moi (vi du 2.4.1, hoac bam Enter de giu nguyen): "

python -c "import json, shutil; from pathlib import Path; p = Path('anlc_update.json'); d = json.loads(p.read_text(encoding='utf-8')); v = '%NEW_VER%'.strip(); d['version'] = v if v else d['version']; d['changelog'] = f'Anotherlfe Tactical Suite v{d[\"version\"]} - Cloud Auto-Update'; p.write_text(json.dumps(d, indent=2), encoding='utf-8'); src = Path(r'c:\Users\Admin\Desktop\RRTool_Public_[unknowncheats.me]_\RRTool_Public\2_src_port'); shutil.copy2(src / 'payload_core.bin', 'payload_core.bin') if (src / 'payload_core.bin').exists() else None; shutil.copy2(src / 'payload_drv.bin', 'payload_drv.bin') if (src / 'payload_drv.bin').exists() else None; print('[OK] Da dong bo payload_core.bin + payload_drv.bin va cap nhat version ->', d['version'])"

git add anlc_update.json payload_core.bin payload_drv.bin
git commit -m "Auto-update ANLC encrypted release"
git push -u origin main --force
echo.
echo ============================================================
echo [HOAN TAT] Da day ban Auto-Update len GitHub thanh cong!
echo Tat ca khach hang mo ANLC_Loader.exe se tu dong nhan ban moi!
echo ============================================================
pause
