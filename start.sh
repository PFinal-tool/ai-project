#!/bin/bash

SESSION="ai-project"

mkdir -p logs

tmux has-session -t $SESSION 2>/dev/null
if [ $? -eq 0 ]; then
  echo "Session already exists: $SESSION"
  tmux attach -t $SESSION
  exit 0
fi

tmux new-session -d -s $SESSION -n main

# Pane layout
tmux split-window -h
tmux split-window -v
tmux select-pane -t 0
tmux split-window -v

# Pane titles
tmux select-pane -t 0 -T Architect
tmux select-pane -t 1 -T Researcher
tmux select-pane -t 2 -T Implementer
tmux select-pane -t 3 -T Reviewer


# Start agents using --prompt parameter
tmux send-keys -t 0 "opencode --agent architect --prompt /Users/pfinal/mini-shell/ai-project/prompts/architect.md -m opencode/kimi-k2.5-free | tee logs/architect.log" C-m
tmux send-keys -t 1 "opencode --agent researcher --prompt /Users/pfinal/mini-shell/ai-project/prompts/researcher.md -m opencode/kimi-k2.5-free | tee logs/researcher.log" C-m
tmux send-keys -t 2 "opencode --agent implementer --prompt /Users/pfinal/mini-shell/ai-project/prompts/implementer.md -m opencode/kimi-k2.5-free | tee logs/implementer.log" C-m
tmux send-keys -t 3 "opencode --agent reviewer --prompt /Users/pfinal/mini-shell/ai-project/prompts/reviewer.md -m opencode/kimi-k2.5-free | tee logs/reviewer.log" C-m

tmux attach -t $SESSION
