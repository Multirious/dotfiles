# === [ tmux ]
# Create a tmux session on a programming project in a directory
function pg_proj() {
  proj_path=$1
  session_name=$2
  session=
  session="Programming $proj_path"
  tmux new-session -d -s $session -n "edit n stuff"
}
