#!/bin/bash
# LIGHT HOPE PK Sync - 主控制脚本

set -e

# 配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_FILES="$SCRIPT_DIR/project_files"
CACHE_DIR="$SCRIPT_DIR/.pk_cache"
GITHUB_USER="williampolicy"
REPO_NAME="pj_801_tools_m024_lh_pk_prj_knoledge_v2"

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# 初始化
init() {
    mkdir -p "$CACHE_DIR/files"
    mkdir -p "$CACHE_DIR/backup"
    [ ! -f "$CACHE_DIR/sync.log" ] && echo "System initialized: $(date)" > "$CACHE_DIR/sync.log"
}

# 从GitHub下载最新文件
download_from_github() {
    echo -e "${BLUE}📥 从GitHub下载最新文件...${NC}"
    
    local base_url="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/main/project_files"
    local count=0
    
    # 下载project_files中的所有文件
    for file in index.html style.css app.js config.json; do
        if curl -sL "$base_url/$file" -o "$CACHE_DIR/files/$file" 2>/dev/null; then
            if [ -s "$CACHE_DIR/files/$file" ] && ! grep -q "404" "$CACHE_DIR/files/$file" 2>/dev/null; then
                echo "  ✓ $file"
                ((count++))
            else
                rm -f "$CACHE_DIR/files/$file"
            fi
        fi
    done
    
    # 从本地project_files复制
    if [ -d "$PROJECT_FILES" ] && [ "$(ls -A $PROJECT_FILES)" ]; then
        cp -r "$PROJECT_FILES"/* "$CACHE_DIR/files/" 2>/dev/null || true
        count=$(ls -1 "$CACHE_DIR/files" | wc -l)
    fi
    
    echo -e "${GREEN}✅ 准备了 $count 个文件${NC}"
}

# 显示上传指南
show_guide() {
    echo ""
    echo -e "${PURPLE}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║     📋 Project Knowledge 上传指南             ║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════════════╝${NC}"
    echo ""
    
    local file_count=$(ls -1 "$CACHE_DIR/files" 2>/dev/null | wc -l)
    
    if [ "$file_count" -eq 0 ]; then
        echo -e "${YELLOW}没有文件需要上传${NC}"
        echo "请先添加文件到 project_files/ 目录"
        return
    fi
    
    echo -e "${YELLOW}📁 待上传文件 ($file_count 个):${NC}"
    for f in "$CACHE_DIR/files"/*; do
        [ -f "$f" ] && echo "  • $(basename $f)"
    done
    
    echo ""
    echo -e "${GREEN}📝 上传步骤:${NC}"
    echo "1. 打开 https://claude.ai"
    echo "2. 进入你的 Project"
    echo "3. 点击 'Edit project' → 'Project knowledge'"
    echo "4. 点击 'Add files'"
    echo "5. 选择这个目录的所有文件:"
    echo -e "   ${YELLOW}$CACHE_DIR/files/${NC}"
    echo ""
    echo "6. 完成后运行:"
    echo -e "   ${GREEN}./pk_sync.sh done${NC}"
}

# 同步流程
sync() {
    echo -e "${PURPLE}🚀 开始同步流程${NC}"
    init
    download_from_github
    show_guide
    echo "Synced at: $(date)" >> "$CACHE_DIR/sync.log"
}

# 标记完成
done_sync() {
    local backup_dir="$CACHE_DIR/backup/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    if [ -d "$CACHE_DIR/files" ] && [ "$(ls -A $CACHE_DIR/files)" ]; then
        mv "$CACHE_DIR/files"/* "$backup_dir/" 2>/dev/null || true
        echo -e "${GREEN}✅ 已标记为完成，文件已备份${NC}"
    fi
    
    echo "Upload completed: $(date)" >> "$CACHE_DIR/sync.log"
}

# 显示状态
status() {
    echo -e "${BLUE}📊 系统状态${NC}"
    
    if [ -f "$CACHE_DIR/sync.log" ]; then
        echo "最近活动:"
        tail -3 "$CACHE_DIR/sync.log"
    fi
    
    local file_count=$(ls -1 "$CACHE_DIR/files" 2>/dev/null | wc -l)
    echo ""
    echo "缓存文件: $file_count 个"
    
    if [ "$file_count" -gt 0 ]; then
        echo -e "${YELLOW}有文件待上传${NC}"
    else
        echo -e "${GREEN}无待上传文件${NC}"
    fi
}

# 主菜单
case "${1:-help}" in
    sync|s)
        sync
        ;;
    done|d)
        done_sync
        ;;
    status|st)
        status
        ;;
    clean)
        rm -rf "$CACHE_DIR"
        echo "✅ 缓存已清理"
        ;;
    help|h|*)
        cat << EOF
${PURPLE}LIGHT HOPE Project Knowledge 同步系统${NC}

使用方法: $0 [命令]

命令:
  sync (s)    - 同步文件并显示上传指南
  done (d)    - 标记上传完成
  status (st) - 显示系统状态
  clean       - 清理缓存
  help (h)    - 显示帮助

${GREEN}快速开始:${NC}
  1. 将文件放入 project_files/ 目录
  2. 运行: ./pk_sync.sh sync
  3. 按指南上传文件到 Project Knowledge
  4. 运行: ./pk_sync.sh done

${BLUE}GitHub仓库:${NC}
  https://github.com/$GITHUB_USER/$REPO_NAME

EOF
        ;;
esac
