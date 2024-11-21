#!/nix/store/0irlcqx2n3qm6b1pc9rsd2i8qpvcccaj-bash-5.2p37/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS_DIR="$CURRENT_DIR"

# shellcheck source=scripts/helpers.sh
source "${HELPERS_DIR}/helpers.sh"

pane_current_path() {
    tmux display -p -F "#{pane_current_path}"
}

display_notice() {
    display_message 'PWD copied to clipboard!'
}

main() {
    local copy_command
    local payload
    # shellcheck disable=SC2119
    copy_command="$(clipboard_copy_command)"
    payload="$(pane_current_path | tr -d '\n')"
    # $copy_command below should not be quoted
    echo "$payload" | $copy_command
    tmux set-buffer "$payload"
    display_notice
}
main
