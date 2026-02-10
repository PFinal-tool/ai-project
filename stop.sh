#!/bin/bash

SESSION="ai-project"
tmux kill-session -t $SESSION
echo "Session stopped: $SESSION"
