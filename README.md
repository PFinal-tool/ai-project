# 多智能体编排

![](https://raw.githubusercontent.com/pfinal-nc/iGallery/master/blog/20260210182200802.png)

```
ai-project/
├── start.sh                # 一键启动 tmux + agents
├── stop.sh                 # 安全关闭 session
├── README.md               # 项目目标（给人看）
├── context.md              # 项目统一上下文（给 AI）
│
├── prompts/                # 角色 Prompt（最重要）
│   ├── architect.md
│   ├── researcher.md
│   ├── implementer.md
│   └── reviewer.md
│
├── workflows/              # 人类操作 SOP
│   └── default.md
│
├── logs/                   # Agent 输出日志
│   ├── architect.log
│   ├── researcher.log
│   ├── implementer.log
│   └── reviewer.log
│
└── notes/                  # 人类裁决 & 记录
    └── decisions.md
```