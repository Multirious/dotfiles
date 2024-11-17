#!/nix/store/mm0pa3z7kk6jh1i9rkxqxjqmd8h1qpxf-bash-5.2p37/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
# shellcheck disable=SC1091
source "${script_dir}/helpers.sh"

# Tests that the default options are set correctly
tmux source "${script_dir}/../catppuccin_options_tmux.conf"
tmux source "${script_dir}/../catppuccin_tmux.conf"

print_option @catppuccin_flavor
print_option @catppuccin_menu_selected_style
print_option @catppuccin_pane_active_border_style
