#!/bin/bash
# ========================================
#  编译答辩PPT (XeLaTeX)
#  使用方式: bash build.sh 或 chmod +x && ./build.sh
# ========================================

MAIN=beamer

echo "[1/2] 第一次编译..."
xelatex -interaction=nonstopmode "$MAIN".tex
if [ $? -ne 0 ]; then
    echo "[ERROR] 编译失败，请检查错误信息"
    exit $?
fi

echo "[2/2] 第二次编译 (交叉引用)..."
xelatex -interaction=nonstopmode "$MAIN".tex

echo ""
echo "========================================"
echo "   编译完成！输出文件: $MAIN.pdf"
echo "========================================"
echo ""

# 清理辅助文件 (可选，取消下面注释以启用)
rm -f "$MAIN".aux "$MAIN".log "$MAIN".nav "$MAIN".out "$MAIN".snm "$MAIN".toc "$MAIN".vrb 2>/dev/null
