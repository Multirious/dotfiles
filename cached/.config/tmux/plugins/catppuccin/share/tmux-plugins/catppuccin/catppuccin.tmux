#!/nix/store/mm0pa3z7kk6jh1i9rkxqxjqmd8h1qpxf-bash-5.2p37/bin/bash

# Set path of script
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux source "${PLUGIN_DIR}/catppuccin_options_tmux.conf"
tmux source "${PLUGIN_DIR}/catppuccin_tmux.conf"
