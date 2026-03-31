#!/usr/bin/env bash
# Dev Skills 安装脚本
# 将技能文件从本仓库复制到目标项目目录
#
# 用法:
#   bash install.sh /path/to/your-project              # 安装所有平台
#   bash install.sh /path/to/your-project --claude      # 仅 Claude Code
#   bash install.sh /path/to/your-project --copilot     # 仅 VS Code Copilot
#   bash install.sh /path/to/your-project --trae        # 仅 Trae
#   bash install.sh /path/to/your-project --claude --trae  # 组合选择

set -euo pipefail

# --- install.sh 所在目录即为 dev-skills 仓库根目录 ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- 参数解析 ---
TARGET_DIR=""
INSTALL_CLAUDE=false
INSTALL_COPILOT=false
INSTALL_TRAE=false
INSTALL_SKILLS=false
ANY_FLAG=false

for arg in "$@"; do
  case "$arg" in
    --claude)  INSTALL_CLAUDE=true;  ANY_FLAG=true ;;
    --copilot) INSTALL_COPILOT=true; ANY_FLAG=true ;;
    --trae)    INSTALL_TRAE=true;    ANY_FLAG=true ;;
    --skills)  INSTALL_SKILLS=true;  ANY_FLAG=true ;;
    --help|-h)
      echo "用法: bash install.sh <目标项目路径> [选项]"
      echo ""
      echo "选项:"
      echo "  不带选项    安装所有平台配置 + 技能脚本"
      echo "  --claude    安装 Claude Code 技能 (.claude/skills/)"
      echo "  --copilot   安装 VS Code Copilot prompt files (.github/prompts/)"
      echo "  --trae      安装 Trae AI rules (.trae/rules/)"
      echo "  --skills    安装技能运行时脚本 (skills/)"
      echo ""
      echo "示例:"
      echo "  bash install.sh ~/my-project"
      echo "  bash install.sh ~/my-project --claude --skills"
      exit 0
      ;;
    -*)
      echo "未知选项: $arg (用 --help 查看用法)"
      exit 1
      ;;
    *)
      if [ -z "$TARGET_DIR" ]; then
        TARGET_DIR="$arg"
      else
        echo "错误: 只能指定一个目标路径 (已有: $TARGET_DIR, 多余: $arg)"
        exit 1
      fi
      ;;
  esac
done

if [ -z "$TARGET_DIR" ]; then
  echo "错误: 请指定目标项目路径"
  echo "用法: bash install.sh <目标项目路径> [--claude] [--copilot] [--trae] [--skills]"
  exit 1
fi

# 转为绝对路径
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
  echo "错误: 目标路径不存在: $TARGET_DIR"
  exit 1
}

# 不带选项 = 全部安装
if [ "$ANY_FLAG" = false ]; then
  INSTALL_CLAUDE=true
  INSTALL_COPILOT=true
  INSTALL_TRAE=true
  INSTALL_SKILLS=true
fi

installed=()

# --- 安装 Claude Code ---
if [ "$INSTALL_CLAUDE" = true ]; then
  mkdir -p "$TARGET_DIR/.claude/skills"
  cp "$SCRIPT_DIR"/.claude/skills/*.md "$TARGET_DIR/.claude/skills/"
  installed+=("Claude Code (.claude/skills/)")
fi

# --- 安装 VS Code Copilot ---
if [ "$INSTALL_COPILOT" = true ]; then
  mkdir -p "$TARGET_DIR/.github/prompts"
  cp "$SCRIPT_DIR"/.github/prompts/*.prompt.md "$TARGET_DIR/.github/prompts/"
  installed+=("VS Code Copilot (.github/prompts/)")
fi

# --- 安装 Trae ---
if [ "$INSTALL_TRAE" = true ]; then
  mkdir -p "$TARGET_DIR/.trae/rules"
  cp "$SCRIPT_DIR"/.trae/rules/*.md "$TARGET_DIR/.trae/rules/"
  installed+=("Trae (.trae/rules/)")
fi

# --- 安装技能脚本 ---
if [ "$INSTALL_SKILLS" = true ]; then
  cp -r "$SCRIPT_DIR"/skills/ "$TARGET_DIR/skills/"
  installed+=("技能脚本 (skills/)")
fi

# --- 完成 ---
echo ""
echo "安装完成! 目标: $TARGET_DIR"
echo "已安装:"
for item in "${installed[@]}"; do
  echo "  - $item"
done
echo ""
echo "使用方式:"
echo "  Claude Code  — 技能自动加载，直接使用"
echo "  VS Code      — 在 Copilot Chat 中用 #eval-runner 引用"
echo "  Trae         — 规则自动加载，直接使用"
