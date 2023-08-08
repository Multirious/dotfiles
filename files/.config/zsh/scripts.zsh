# === [ tmux ]

# Attach to a tmux session.
# if already in a session then switch
function tmux_no_nest_attach() {
  session=$1
  if [[ -v TMUX ]]; then
    tmux switch-client -t $session
  else
    tmux attach-session -t $session
  fi
}

# 
function _tmux_new_session() {
  session_name=$1
  window_name="${2:-"Window"}"
  tmux new-session -d -s $session_name -n $window_name
  [[ $? -ne 0 ]] && return 1
}

# Create a tmux session in current directory.
# Will created panes and window intended for programming projects.
# If some parameter is passed then that will be the session's name,
# otherwise use current directory basename.
function pgproj() {
  session="${1:-$(basename $PWD)}"

  _tmux_new_session $session "Edit n stuff"
  [[ $? -ne 0 ]] && return 1

  tmux split-window -t $session -h
  tmux select-pane -t 0
  tmux send-keys -t $session:0.0 "hx ." Enter
  tmux new-window -t $session:1 -n "Other"
  tmux select-window -t $session:1
  tmux select-window -t $session:0
  tmux select-pane -t 1

  if [[ -v TMUX ]]; then
    tmux switch-client -t $session
  else
    tmux attach-session -t $session
  fi
}
