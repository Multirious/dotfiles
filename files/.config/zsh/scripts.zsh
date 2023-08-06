# === [ tmux ]

# Create a tmux session in current directory.
# Will created panes and window inteded for programming.
# If some parameter is passed then that will be the session's name,
# otherwise use current directory basename.
function pg_proj() {
  session="${1:-$(basename $PWD)}"

  tmux new-session -d -s $session -n "Edit n Stuff"
  [[ $? -ne 0 ]] && return 1

  tmux split-window -h
  tmux select-pane -t 0
  tmux send-keys "hx ." Enter
  tmux new-window -t $session:1 -n "Other"
  tmux select-window -t $session:1
  tmux select-window -t $session:0
  tmux select-pane -t 1

  [[ -v TMUX ]]  && tmux detach
  tmux a -t $session
}
