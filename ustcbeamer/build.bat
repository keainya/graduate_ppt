@echo off
REM ===================================================
REM  build.bat — USTC Beamer 编译与清理脚本 (Windows)
REM
REM  用法:
REM    build.bat           编译 main.pdf (xelatex ×3)
REM    build.bat clean     清除临时文件
REM    build.bat distclean  清除临时文件 + PDF
REM ===================================================

setlocal enabledelayedexpansion
set MAIN=main

if "%1"==""             goto :build
if /i "%1"=="build"     goto :build
if /i "%1"=="clean"     goto :clean
if /i "%1"=="distclean" goto :distclean

echo 用法: build.bat {build ^| clean ^| distclean}
exit /b 1

:build
echo [INFO] 开始编译 %MAIN%.tex (第 1 遍)...
xelatex -file-line-error -halt-on-error -interaction=nonstopmode -synctex=1 %MAIN%.tex
if %errorlevel% neq 0 (
	echo [ERR]  第 1 遍编译失败!
	exit /b %errorlevel%
)

echo [INFO] 第 2 遍编译 (交叉引用)...
xelatex -file-line-error -halt-on-error -interaction=nonstopmode -synctex=1 %MAIN%.tex
if %errorlevel% neq 0 (
	echo [ERR]  第 2 遍编译失败!
	exit /b %errorlevel%
)

echo [INFO] 第 3 遍编译 (目录/书签)...
xelatex -file-line-error -halt-on-error -interaction=nonstopmode -synctex=1 %MAIN%.tex
if %errorlevel% neq 0 (
	echo [ERR]  第 3 遍编译失败!
	exit /b %errorlevel%
)

echo [OK]   编译完成 → %MAIN%.pdf
goto :eof

:clean
echo [INFO] 清除临时文件...
set COUNT=0

for %%f in (
	%MAIN%.aux %MAIN%.log %MAIN%.out
	%MAIN%.toc %MAIN%.nav %MAIN%.snm
	%MAIN%.vrb %MAIN%.synctex.gz
	%MAIN%.bbl %MAIN%.blg %MAIN%.bcf
	%MAIN%.run.xml %MAIN%.fls
	%MAIN%.fdb_latexmk %MAIN%.xdv
) do (
	if exist "%%f" (
		del /f /q "%%f" >nul 2>&1
		set /a COUNT+=1
	)
)

echo [OK]   已清除 !COUNT! 个临时文件
goto :eof

:distclean
echo [INFO] 清除临时文件及 PDF...
call :clean
if exist "%MAIN%.pdf" (
	del /f /q "%MAIN%.pdf" >nul 2>&1
	echo [OK]   已删除 %MAIN%.pdf
)
goto :eof
