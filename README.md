# Dev Skills

AI 编程助手技能集合，支持 Claude Code、VS Code (GitHub Copilot) 和 Trae。

## 安装

### 一行命令安装

下载本仓库后，在 `dev-skills` 目录下运行：

```bash
bash install.sh /path/to/your-project
```

这会将所有平台的技能文件复制到目标项目。

**按平台选装：**

```bash
bash install.sh /path/to/your-project --claude              # 仅 Claude Code
bash install.sh /path/to/your-project --copilot             # 仅 VS Code Copilot
bash install.sh /path/to/your-project --trae                # 仅 Trae
bash install.sh /path/to/your-project --claude --trae       # 组合选择
bash install.sh /path/to/your-project --skills              # 仅技能运行时脚本
```

### 手动安装

如果不想用脚本，直接复制对应目录即可（以 `TARGET` 代替你的项目路径）：

```bash
TARGET=/path/to/your-project

# 技能运行时脚本（所有技能共用，必须复制）
cp -r dev-skills/skills/ "$TARGET/skills/"

# Claude Code
mkdir -p "$TARGET/.claude/skills"
cp dev-skills/.claude/skills/*.md "$TARGET/.claude/skills/"

# VS Code (GitHub Copilot)
mkdir -p "$TARGET/.github/prompts"
cp dev-skills/.github/prompts/*.prompt.md "$TARGET/.github/prompts/"

# Trae
mkdir -p "$TARGET/.trae/rules"
cp dev-skills/.trae/rules/*.md "$TARGET/.trae/rules/"
```

### 安装后使用

| 平台 | 使用方式 |
|------|---------|
| Claude Code | 技能自动加载，直接在对话中使用 |
| VS Code Copilot | 在 Copilot Chat 中用 `#eval-runner` 引用 |
| Trae | 规则自动加载，直接在对话中使用 |

## 可用技能

| 技能 | 说明 | 文档 |
|------|------|------|
| **eval-runner** | 评测工具 — 管理测试数据环境、导入测试集、执行自动评测（LLM-as-a-Judge）、查看和清理评测结果 | [SKILL.md](skills/eval-runner/SKILL.md) |

## 目录结构

```
dev-skills/
├── install.sh                       # 一键安装脚本
├── skills/                          # 技能目录（运行时脚本和配置）
│   └── eval-runner/
│       ├── SKILL.md                 # 技能定义文档
│       ├── .env.example             # 环境变量模板
│       ├── eval_config.yaml.example # 评测配置模板
│       ├── scripts/                 # Python 脚本
│       └── qmsdata/                 # 数据导入模块
├── .claude/skills/                  # Claude Code 技能入口
├── .github/prompts/                 # VS Code Copilot prompt files
├── .trae/rules/                     # Trae AI rules
└── README.md
```

## 添加新技能

1. 在 `skills/` 下创建新目录，如 `skills/my-new-skill/`
2. 编写 `SKILL.md`（带 YAML frontmatter）
3. 为各平台生成对应配置文件：
   - `.claude/skills/my-new-skill.md` — Claude Code
   - `.github/prompts/my-new-skill.prompt.md` — VS Code Copilot
   - `.trae/rules/my-new-skill.md` — Trae
4. 更新本 README 的技能列表

## 前置条件

- Python 3.10+
- Poetry 包管理器
- 各技能的具体依赖见对应 SKILL.md
