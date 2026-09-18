@echo off
title StrateX Windows 1.0
color 0A
setlocal EnableExtensions

:anamenu
cls
echo ================================================
echo           STRATEX WINDOWS 1.0
echo ================================================
echo.
echo  [1] Oyun Surucusu
echo  [2] Bilgi
echo  [3] Cikis
echo.
echo ================================================
set "secim="
set /p secim="Seciminiz (1-3): "

if "%secim%"=="1" goto oyunsurucusu
if "%secim%"=="2" goto bilgi
if "%secim%"=="3" exit /b
goto anamenu


REM ================= BILGI =================
:bilgi
cls
echo ================================================
echo            BILGI / KULLANIM KILAVUZU
echo ================================================
echo.
echo  Bu scriptleri calistirmak icin oyununuzun
echo  acik olmasi gerekebilir.
echo.
echo  Optimizasyonlar sadece desteklenen oyunlarda
echo  uygulanir.
echo.
echo  GTA 5 ve Minecraft icin performans ayarlari
echo  uygulanir.
echo.
echo  [0] Ana Menu
echo.
echo ================================================

set "bilgi_secim="
set /p bilgi_secim="Seciminiz: "

if "%bilgi_secim%"=="0" goto anamenu
goto bilgi


REM ================= OYUN SURUCUSU =================
:oyunsurucusu
cls
echo ================================================
echo              OYUN SURUCUSU
echo ================================================
echo.
echo  [1] GTA 5 Optimizasyon
echo  [2] Minecraft Optimizasyon
echo  [3] Geri Don
echo.
echo ================================================
set "secim2="
set /p secim2="Seciminiz (1-3): "

if "%secim2%"=="1" (
    set "oyunadi=GTA 5"
    set "exeadi=GTA5.exe"
    goto optimizasyon
)

if "%secim2%"=="2" (
    set "oyunadi=Minecraft"
    set "exeadi=javaw.exe"
    goto optimizasyon
)

if "%secim2%"=="3" goto anamenu
goto oyunsurucusu


REM ================= FULL OPTIMIZASYON =================
:optimizasyon
cls
echo ================================================
echo       %oyunadi% OPTIMIZASYONU UYGULANIYOR
echo ================================================
echo.

echo [1/7] Guc plani "Yuksek Performans" olarak ayarlaniyor...
powercfg /setactive SCHEME_MIN >nul 2>&1

if errorlevel 1 (
    echo      [!] Guc plani ayarlanamadi.
) else (
    echo      Tamam.
)

echo.
echo [2/7] Windows oyun zamanlama ayarlaniyor...

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1

echo      Tamam.

echo.
echo [3/7] Xbox Game Bar / Game DVR kapatiliyor...

reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

echo      Tamam.

echo.
echo [4/7] Sistem yaniti ayarlaniyor...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1

echo      Tamam.

echo.
echo [5/7] DNS onbellegi temizleniyor...

ipconfig /flushdns >nul 2>&1

echo      Tamam.

echo.
echo [6/7] Gecici dosyalar temizleniyor...

del /q /f /s "%temp%\*.*" >nul 2>&1

echo      Tamam.

echo.
echo [7/7] %exeadi% High Priority yapiliyor...
echo.

REM ================= PROCESS PRIORITY =================

powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -Command ^
"$p=Get-Process -Name '%exeadi:.exe=%' -ErrorAction SilentlyContinue; if(-not $p){exit 1}; foreach($x in $p){try{$x.PriorityClass='High'}catch{exit 2}}"

if errorlevel 2 (
    echo      [!] %exeadi% bulundu fakat High Priority uygulanamadi.
) else if errorlevel 1 (
    echo      [!] %exeadi% su an acik degil.
) else (
    echo      [OK] %exeadi% High Priority yapildi.
)


REM ================= SON =================

echo.
echo ================================================
echo       %oyunadi% OPTIMIZASYONU TAMAMLANDI
echo ================================================
echo.
echo  [0] Oyun Surucusune Don
echo.
echo ================================================

:optimizasyon_bekle
choice /c 0 /n /m ""

if errorlevel 1 goto oyunsurucusu

goto optimizasyon_bekle