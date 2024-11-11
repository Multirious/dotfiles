{ pkgs, ... }:
{
  config = /*bash*/''
    set-option -g status-position top

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

    # set -g @catppuccin_flavour 'mocha'

    # set -g @plugin 'tmux-plugins/tpm'
    # set -g @plugin 'tmux-plugins/tmux-sensible'
    # set -g @plugin 'christoomey/vim-tmux-navigator'
    # set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
    # set -g @plugin 'tmux-plugins/tmux-yank'

    # run '~/.tmux/plugins/tpm/tpm'

    # set vi-mode
    set-window-option -g mode-keys vi
    # keybindings
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

    # open split pane with current path
    bind 'h' split-window -v -c "#{pane_current_path}"
    bind 'v' split-window -h -c "#{pane_current_path}"
    unbind '%'
    unbind '"'
  '';
  plugins = with pkgs.tmuxPlugins; [
    {
      plugin = catppuccin;
      preConfig = /*bash*/''
        # set -g @catppuccin_flavor "latte"

        # set -g @catppuccin_status_background "none"
      '';
      postConfig  = /*bash*/''
        # set -g status-right-length 100
        # set -g status-left-length 100
        # set -g status-right '#[fg=#{@thm_crust},bg=#{@thm_teal}] tf: #S '
        # set -g status-left ""
        # set -g status-right "#{E:@catppuccin_status_application}"
        # set -agF status-right "#{E:@catppuccin_status_cpu}"
        # set -ag status-right "#{E:@catppuccin_status_session}"
        # set -ag status-right "#{E:@catppuccin_status_uptime}"
        # set -agF status-right "#{E:@catppuccin_status_battery}"
      '';
    }
    yank
    vim-tmux-navigator
    cpu
    battery
  ];
}
#:w<ret>:sh ./link && tmux source<minus>file ~/.config/tmux/tmux.conf && echo "tmux updated"<ret>
