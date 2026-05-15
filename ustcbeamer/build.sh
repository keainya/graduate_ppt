#!/bin/bash
#
# build.sh — USTC Beamer 编译与清理脚本
#
# 用法:
#   ./build.sh          编译 main.pdf (xelatex ×3)
#   ./build.sh clean    清除临时文件
#   ./build.sh distclean 清除临时文件 + PDF
#

set -e

MAIN="main"
XELATEX_ARGS="-file-line-error -halt-on-error -interaction=nonstopmode -synctex=1"

# 彩色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC}  $1"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
err()   { echo -e "${RED}[ERR]${NC}   $1"; }

TEXFILES=(
	"${MAIN}.aux" "${MAIN}.log" "${MAIN}.out"
	"${MAIN}.toc" "${MAIN}.nav" "${MAIN}.snm"
	"${MAIN}.vrb" "${MAIN}.synctex.gz"
	"${MAIN}.bbl" "${MAIN}.blg" "${MAIN}.bcf"
	"${MAIN}.run.xml" "${MAIN}.fls"
	"${MAIN}.fdb_latexmk" "${MAIN}.xdv"
)

do_build() {
	info "开始编译 ${MAIN}.tex (第 1 遍)..."
	xelatex ${XELATEX_ARGS} "${MAIN}.tex"

	info "第 2 遍编译 (交叉引用)..."
	xelatex ${XELATEX_ARGS} "${MAIN}.tex"

	info "第 3 遍编译 (目录/书签)..."
	xelatex ${XELATEX_ARGS} "${MAIN}.tex"

	ok "编译完成 → ${MAIN}.pdf"
}

do_clean() {
	info "清除临时文件..."
	local removed=0
	for f in "${TEXFILES[@]}"; do
		if [ -f "$f" ]; then
			rm -f "$f"
			((removed++))
		fi
	done
	ok "已清除 ${removed} 个临时文件"
}

do_distclean() {
	info "清除临时文件及 PDF..."
	do_clean
	if [ -f "${MAIN}.pdf" ]; then
		rm -f "${MAIN}.pdf"
		ok "已删除 ${MAIN}.pdf"
	fi
}

case "${1:-build}" in
	build)
		do_build
		;;
	clean)
		do_clean
		;;
	distclean)
		do_distclean
		;;
	*)
		echo "用法: $0 {build|clean|distclean}"
		exit 1
		;;
esac
