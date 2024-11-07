{ pkgs, ... }:
{
  config = /* bash */''
    # better colors
    set-option -sa terminal-overrides ",xterm*:Tc"

    # Vim style pane selection
    bind h select-pane -L
    bind j select-pane -D 
    bind k select-pane -U
    bind l select-pane -R

    # shift alt vim keys to switch windows
    bind -n M-H previous-window
    bind -n M-L next-window

    set -g @catppuccin_flavour 'mocha'

    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    set -g @plugin 'christoomey/vim-tmux-navigator'
    set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
    set -g @plugin 'tmux-plugins/tmux-yank'

    run '~/.tmux/plugins/tpm/tpm'

    # set vi-mode
    set-window-option -g mode-keys vi
    # keybindings
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

    # open split pane with current path
    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"
  '';
  plugins = with pkgs.tmuxPlugins; [
     {
       plugin = catppuccin;
       config  = "set -g @catppuccin_flavour 'mocha'";
     }
     yank
     vim-tmux-navigator
  ];
}
