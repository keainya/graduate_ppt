@echo off
REM ========================================
REM  编译答辩PPT (XeLaTeX)
REM  使用方式: 双击运行 或 命令行执行 build.bat
REM ========================================

set MAIN=beamer

echo [1/2] 第一次编译...
xelatex -interaction=nonstopmode %MAIN%.tex
if %errorlevel% neq 0 (
    echo [ERROR] 编译失败，请检查错误信息
    pause
    exit /b %errorlevel%
)

echo [2/2] 第二次编译 (交叉引用)...
xelatex -interaction=nonstopmode %MAIN%.tex

echo.
echo ========================================
echo   编译完成！输出文件: %MAIN%.pdf
echo ========================================
echo.

REM 清理辅助文件 (可选，取消下面注释以启用)
REM del /q %MAIN%.aux %MAIN%.log %MAIN%.nav %MAIN%.out %MAIN%.snm %MAIN%.toc %MAIN%.vrb 2>nul

pause
