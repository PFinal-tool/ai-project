# AI 项目标准流程（多 agent 并行协同）

- **Architect / Researcher / Implementer / Reviewer 四个 agent 同时启动**，在各自窗格并行运行。
- **协同方式**：以 `context.md` 为统一背景，以 `notes/decisions.md` 为共享决策与结论池；各角色阅读并追加自己的输出，供其他角色参考。
- **人类**：在适当时机裁决、整理 `notes/decisions.md`；必要时修改 `context.md` 后重新跑 start.sh 进行下一轮。
