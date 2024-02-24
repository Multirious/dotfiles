function tmux_programing_session() {
  local name=$1

  tmux new-session -d -s $name -n "Editor & Console"
  tmux split-window -t $name -h
  tmux select-pane -t 0
  tmux send-keys -t $name:0.0 "hx ." Enter
  tmux new-window -t $name:1 -n "Other"
  tmux select-window -t $name:1
  tmux select-window -t $name:0
  tmux select-pane -t 0
}

function select_repository() {
  repo=$(
    find $GIT_REPOS -maxdepth 2 -mindepth 2 |
    cut -c $(("${#GIT_REPOS}"+2))- |
    fzf
  )
  echo $repo
}

