# pj_801_tools_m024_lh_pk_prj_knoledge_v2

LIGHT HOPE Project Knowledge Sync System - 独立的PK同步解决方案

## 🚀 快速开始

```bash
# 同步文件
./pk_sync.sh sync

# 标记完成
./pk_sync.sh done

# 查看状态
./pk_sync.sh status
```

## 📁 项目结构

```
pj_801_tools_m024_lh_pk_prj_knoledge_v2/
├── project_files/     # 要同步到PK的文件
│   ├── index.html
│   ├── style.css
│   ├── app.js
│   └── config.json
├── pk_sync.sh        # 主同步脚本
├── docs/             # 文档
└── .pk_cache/        # 本地缓存（自动创建）
```

## 🔄 工作流程

1. **添加文件**: 将文件放入 `project_files/` 目录
2. **提交到GitHub**: `git add . && git commit -m "Update" && git push`
3. **运行同步**: `./pk_sync.sh sync`
4. **上传到PK**: 按照指南手动上传
5. **标记完成**: `./pk_sync.sh done`

## 📝 更新Project Knowledge

当需要更新时，只需重复上述流程即可。

## 🔗 链接

- GitHub: https://github.com/williampolicy/pj_801_tools_m024_lh_pk_prj_knoledge_v2
- Claude.ai: https://claude.ai

---
Created with ❤️ by LIGHT HOPE LLC
