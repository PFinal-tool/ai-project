#!/bin/bash

# 从 start.sh 写入的 tmux 会话环境读取工作目录（与 start.sh 保持一致）
SESSION="ai-project"
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
[[ "$SCRIPT_DIR" == ~* ]] && SCRIPT_DIR="${SCRIPT_DIR/#\~/$HOME}"
SCRIPT_DIR="$(cd "$SCRIPT_DIR" && pwd)"

if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "未找到 tmux 会话 $SESSION，请先执行 start.sh"
  exit 1
fi

PROJECT_ROOT="$(tmux showenv -t "$SESSION" PROJECT_ROOT 2>/dev/null | sed 's/^PROJECT_ROOT=//')"
if [ -z "$PROJECT_ROOT" ]; then
  echo "无法从会话读取 PROJECT_ROOT，请先在同一项目目录下重新执行 start.sh"
  exit 1
fi
PHASE_FILE="$PROJECT_ROOT/.workflow_phase"
# 优先使用 start.sh 写入的 SCRIPT_DIR（与 start 时一致）
SCRIPT_DIR_FROM_SESSION="$(tmux showenv -t "$SESSION" SCRIPT_DIR 2>/dev/null | sed 's/^SCRIPT_DIR=//')"
[ -n "$SCRIPT_DIR_FROM_SESSION" ] && SCRIPT_DIR="$SCRIPT_DIR_FROM_SESSION"

phase=1
[ -f "$PHASE_FILE" ] && phase=$(cat "$PHASE_FILE")

case $phase in
  1)
    echo "进入阶段 2：启动 Researcher 与 Implementer"
    # 清空当前行后发送命令
    tmux send-keys -t 1 C-c
    tmux send-keys -t 2 C-c
    sleep 0.3
    tmux send-keys -t 1 "cd $PROJECT_ROOT && opencode --agent researcher --prompt $SCRIPT_DIR/prompts/researcher.md -m opencode/kimi-k2.5-free | tee $PROJECT_ROOT/logs/researcher.log" C-m
    tmux send-keys -t 2 "cd $PROJECT_ROOT && opencode --agent implementer --prompt $SCRIPT_DIR/prompts/implementer.md -m opencode/kimi-k2.5-free | tee $PROJECT_ROOT/logs/implementer.log" C-m
    # pane 3 保持监听，仅追加一行提示（不打断 while 循环）
    tmux send-keys -t 3 "echo ''; echo '>>> 阶段 2 已启动。Researcher/Implementer 完成后在本目录执行: touch .workflow-ready'" C-m
    echo "2" > "$PHASE_FILE"
    ;;
  2)
    echo "进入阶段 3：启动 Reviewer"
    tmux send-keys -t 3 C-c
    sleep 0.3
    tmux send-keys -t 3 "cd $PROJECT_ROOT && opencode --agent reviewer --prompt $SCRIPT_DIR/prompts/reviewer.md -m opencode/kimi-k2.5-free | tee $PROJECT_ROOT/logs/reviewer.log" C-m
    echo "3" > "$PHASE_FILE"
    echo "流程已全部启动。Reviewer 完成后，人类裁决并写入 notes/decisions.md。"
    ;;
  3)
    echo "流程已全部启动。请人类裁决后写入 notes/decisions.md；必要时修改 context.md 并重新执行 ./start.sh。"
    ;;
  *)
    echo "未知阶段 $phase"
    exit 1
    ;;
esac
