{ callPackage, pkgs }:
let
  inherit (pkgs) writeText symlinkJoin;
  keyMapper = (modalKeyMappings:
    callPackage ./tmux-key-mapper.nix { inherit modalKeyMappings; }
  );

  runPlugin = plugin:
    let
      rtp = pkgs.lib.strings.removePrefix "${plugin.out}/" plugin.rtp;
    in
    ''
      run-shell '#{d:current_file}/plugins/${rtp}'
    '';

  plugins = with pkgs.tmuxPlugins; {
    # yank = yank;
    # catppuccin = catppuccin.overrideAttrs (attr: {
    #   src = pkgs.fetchFromGitHub {
    #     owner = "catppuccin";
    #     repo = "tmux";
    #     rev = "v2.1.0";
    #     hash = "sha256-kWixGC3CJiFj+YXqHRMbeShC/Tl+1phhupYAIo9bivE=";
    #   };
    # });
  };
  pluginsDrv = symlinkJoin {
    name = "dotfiles-tmux-plugins";
    paths = (builtins.attrValues plugins);
  };

  modalKeyMappings =
  let
    extraVar =''
      %hidden copy_cursor_y_abs='#{e|-|:#{e|+|:#{history_size},#{copy_cursor_y}},#{scroll_position}}'
      %hidden selection_latest_x='#{?#{>:#{selection_start_y},#{selection_end_y}},#{selection_start_x},#{?#{<:#{selection_start_y},#{selection_end_y}},#{selection_end_x},#{?#{>:#{selection_start_x},#{selection_end_x}},#{selection_start_x},#{selection_end_x}}}}'
      %hidden selection_latest_y='#{?#{>:#{selection_start_y},#{selection_end_y}},#{selection_start_y},#{selection_end_y}}'
      %hidden selection_forward='#{&&:#{==:#{copy_cursor_x},#{E:selection_latest_x}},#{==:#{E:copy_cursor_y_abs},#{E:selection_latest_y}}}'
      %hidden selection_height='#{?#{>:#{selection_start_y},#{selection_end_y}},#{e|-|:#{selection_start_y},#{selection_end_y}},#{e|-|:#{selection_end_y},#{selection_start_y}}}'
      %hidden selection_oneline='#{==:#{selection_start_y},#{selection_end_y}}'
    '';
  in
  {
    v = /*bash*/''
      if -F '#{!=:#{@mode},extend}' {
        set -p @mode 'extend'
      } {
        set -p @mode 'normal'
      }
    '';
    h = /*bash*/''
      send -X cursor-left
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    j = /*bash*/''
      send -X cursor-down
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    k = /*bash*/''
      send -X cursor-up
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    l = /*bash*/''
      send -X cursor-right
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    w = /*bash*/''
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      send -X next-word
    '';
    e = /*bash*/''
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      send -X next-word-end
    '';
    b = /*bash*/''
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      send -X previous-word
    '';
    C-u = /*bash*/''
      send -X halfpage-up
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    C-d = /*bash*/''
      send -X halfpage-down
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    y = /*bash*/''
      send -X copy-selection-and-cancel
      run-shell -b '
        if [[ -n $WAYLAND_DISPLAY ]]; then
          tmux show-buffer | wl-copy
        elif [[ -n $DISPLAY ]]; then
          tmux show-buffer | xclip -sel clip
        else
          tmux display-message "No configured copy command (Maybe WAYLAND_DISPLAY or DISPLAY is not set)"
        fi'
    '';
    x = /*bash*/''
      ${extraVar}
      if -F '#{E:selection_forward}' {
        send -X other-end
      } 
      send -X start-of-line
      send -X other-end
      send -X cursor-right
      send -X end-of-line
    '';
    X = /*bash*/''
      ${extraVar}
      if -F '#{E:selection_forward}' {
        send -X end-of-line
        send -X other-end
        send -X start-of-line
        send -X other-end
      } {
        send -X start-of-line
        send -X other-end
        send -X end-of-line
        send -X other-end
      }
    '';
    M-x = /*bash*/''
      ${extraVar}
      if -F '#{!=:#{E:selection_oneline},1}' {
        if -F '#{==:#{E:selection_height},1}' {
          if -F '#{E:selection_forward}' {

          } {

          } 
        } {
          if -F '#{E:selection_forward}' {
            send -X cursor-right
            send -X cursor-up
            send -X end-of-line
            send -X other-end
            send -X cursor-left
            send -X cursor-down
            send -X start-of-line
            send -X other-end
          } {
            send -X cursor-left
            send -X cursor-down
            send -X start-of-line
            send -X other-end
            send -X cursor-right
            send -X cursor-up
            send -X end-of-line
            send -X other-end
          } 
        }
      }
    '';
    g = {
      g = /*bash*/''
        send -X history-top
        if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      '';
      e = /*bash*/''
        send -X history-bottom
        if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      '';
      h = /*bash*/''
        send -X start-of-line
        if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      '';
      l = /*bash*/''
        send -X end-of-line
        if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      '';
      s = /*bash*/''
        send -X back-to-indentation
        if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      '';
    };
    "\\;" = /*bash*/''
      send -X begin-selection
    '';
    "M-\\;" = /*bash*/''
      send -X other-end
    '';
    "M-:" = /*bash*/''
      ${extraVar}
      if -F '#{!=:#{E:selection_forward},1}' {
        send -X other-end
      }
    '';
    "]" = {
      p = /*bash*/''
        send -X next-paragraph
        if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      '';
    };
    "[" = {
      p = /*bash*/''
        send -X previous-paragraph
        if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      '';
    };
    m = {
      m = /*bash*/''
        send -X next-matching-bracket
        if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      '';
    };
    "/" = /*bash*/''
      command-prompt -T search -p "search:" {
        set -up @mode
        set -up @current_keys
        send -X clear-selection
        send -X search-forward "%%"
      }
    '';
    "?" = /*bash*/''
      command-prompt -T search -p "search:" {
        set -up @mode
        set -up @current_keys
        send -X clear-selection
        send -X search-backward "%%"
      }
    '';
    "n" = /*bash*/''
      set -up @mode
      set -up @current_keys
      send -X clear-selection
      send -X search-again
    '';
    "N" = /*bash*/''
      set -up @mode
      set -up @current_keys
      send -X clear-selection
      send -X search-reverse
    '';
  };
  helixConf = writeText "dotfiles-tmux-helixconf" ''
    ${keyMapper modalKeyMappings}
  '';
  config = writeText "dotfiles-tmuxconf" (/*bash*/''
    set -g default-terminal "xterm-256color"
    set -sa terminal-overrides ",xterm*:Tc"
    # set -sa terminal-features ",*:sixel"

    set -g status-position top
    set -g set-clipboard on
    set -g base-index 1
    set -g pane-base-index 1
    set -g renumber-windows on
    set -g pane-border-indicators colour
    set -g pane-border-lines single
    set -g pane-border-status bottom
    set -g mode-keys vi
    set -g cursor-style 'bar'
    set -g status-interval 1
    # set -g status-keys vi
    set -g mouse on
    set -g detach-on-destroy off

    set -g monitor-activity off
    set -g monitor-bell on
    set -g monitor-silence 120
    set -g visual-bell off
    set -g visual-silence on
    set -g bell-action any
    set -g silence-action other
    set -g activity-action none

    # run-shell -b 'while IFS= read -r line; do; result=$(echo "$line" | cut -d' ' -f1); echo "$result"; done < $(tmux show-hooks -g)'

    set-hook -gu alert-silence
    set-hook -ga alert-silence {
      # hide that damn bar
      display -d 1 '#[#{E:status-style}]#{E:status-format[0]}'
    }

    set-hook -gu alert-bell
    set-hook -ga alert-bell {
      set -w @bell_flag 1
      if-shell -F '#{window_active}' {
        run -b -d 2 -C {
          set -w @bell_flag 0
        }
      }
    }

    set-hook -gu after-select-window
    set-hook -ga after-select-window {
      run -b -d 2 -C {
        set -w @bell_flag 0
      }
    }

    unbind '%'
    unbind '"'
    unbind [
    unbind z
    unbind -T copy-mode-vi -a
    unbind -T copy-mode -a

    bind -n M-h if -F '#{!=:#{window_zoomed_flag},1}' {
      select-pane -L
    }
    bind -n M-j if -F '#{!=:#{window_zoomed_flag},1}' {
      select-pane -D
    }
    bind -n M-k if -F '#{!=:#{window_zoomed_flag},1}' {
      select-pane -U
    }
    bind -n M-l if -F '#{!=:#{window_zoomed_flag},1}' {
      select-pane -R
    }

    bind -n M-[ previous-window
    bind -n M-] next-window

    bind -n M-C-h resize-pane -L 1
    bind -n M-C-j resize-pane -D 1
    bind -n M-C-k resize-pane -U 1
    bind -n M-C-l resize-pane -R 1

    bind -n M-H run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -L; tmux swap-pane -t $old'
    bind -n M-J run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -D; tmux swap-pane -t $old'
    bind -n M-K run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -U; tmux swap-pane -t $old'
    bind -n M-L run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -R; tmux swap-pane -t $old'

    bind-key -n "M-{" "swap-window -t -1 ; previous-window"
    bind-key -n "M-}" "swap-window -t +1 ; next-window"

    bind h split-window -v -c "#{pane_current_path}" 
    bind v split-window -h -c "#{pane_current_path}"

    bind -n M-z resize-pane -Z

    bind -n M-1 select-window -t 1
    bind -n M-2 select-window -t 2
    bind -n M-3 select-window -t 3
    bind -n M-4 select-window -t 4
    bind -n M-5 select-window -t 5
    bind -n M-6 select-window -t 6
    bind -n M-7 select-window -t 7
    bind -n M-8 select-window -t 8
    bind -n M-9 select-window -t 9

    bind r source ~/.config/tmux/tmux.conf \; display "Reloaded"

    bind -n M-c {
      copy-mode -H
    }
    bind -T copy-mode-vi M-c send -X cancel
    bind -T copy-mode-vi C-c send -X cancel
    bind -T copy-mode-vi Escape set -up @current_keys \; set -up @mode

    source-file -F "#{d:current_file}/helix.conf"

    set -g @a1 'orange'
    set -g @a2 'yellow'
    set -g @bg 'white'
    set -g @bg2 'darkgray'
    set -g @fg 'black'
    set -g @fill 'terminal'

    set -g @normal_mode_color 'default'
    set -g @copy_mode_color 'pink'
    set -g @view_mode_color 'brightgreen'
    set -g @tree_mode_color 'brightyellow'

    set -g status-style 'fill=#{@fill} bg=#{@fill}'

    set -g status-right-length 100
    set -g status-left-length 100
    set -g status-left '#[fg=#{@fg} bg=#{@bg}]#[push-default]#[fg=#{@bg} bg=#{@fill}]#[default]  #{session_name} #[fg=#{@bg} bg=#{@fill}]#[pop-default]'
    set -g status-right '#[fg=#{@fg} bg=#{@bg}]#[push-default]#[fg=#{@a1} bg=#{@fill}]#[bg=#{@a1}] #[fg=#{@bg2} bg=#{@a1}]#[default bg=#{@bg2}] #{host} #[fg=#{@bg} bg=#{@bg2}]#[default] %H:%M:%S  %d/%b/%y #[pop-default]'

    set -g window-status-bell-style '''
    set -g window-status-activity-style '''

    set -g window-status-style '''

    %hidden window_attr='#{?#{window_zoomed_flag}, 󰍉,}#{?#{@bell_flag}, ,}#{?#{window_silence_flag}, 󰒲,}'

    set -g window-status-separator ' '
    set -g window-status-format '#[fg=#{@fg} bg=#{@bg}]#[push-default]#[fg=#{@bg} bg=#{@fill}]#[default] #{window_index}#{E:window_attr} #[default] #{window_name} #[fg=#{@bg} bg=#{@fill}]#[pop-default]'
    set -g window-status-current-format '#[fg=#{@fg} bg=#{@bg}]#[push-default]#[fg=#{@a1} bg=#{@fill}]#[default]#[bg=#{@a1}] #{window_index}#{E:window_attr} #[fg=#{@bg}]#[default] #{window_name} #[fg=#{@bg} bg=#{@fill}]#[pop-default]'

    %hidden copy_cursor_y_abs='#{e|-|:#{e|+|:#{history_size},#{copy_cursor_y}},#{scroll_position}}'
    %hidden is_no_mode='#{==:#{pane_mode},}'
    %hidden is_copy_mode='#{==:#{pane_mode},copy-mode}'
    %hidden is_view_mode='#{==:#{pane_mode},view-mode}'
    %hidden is_tree_mode='#{==:#{pane_mode},tree-mode}'
    %hidden is_other_mode='#{!=:#{m|r:^$|copy-mode|view-mode|tree-mode,#{pane_mode}},1}'
    %hidden is_vi_keys='#{||:#{E:is_copy_mode},#{E:is_view_mode}}'
    %hidden is_any_current_keys='#{!=:#{@current_keys},}'
    set -g @pane_border_left '#{?pane_active,#{?#{E:is_no_mode}, NORM ,}#{?#{E:is_copy_mode}, #[fg=#{@copy_mode_color}]COPY ,}#{?#{E:is_view_mode}, #[fg=#{@view_mode_color}]VIEW ,}#{?#{E:is_tree_mode}, #[fg=#{@tree_mode_color}]TREE ,}#{?#{E:is_other_mode}, #[fg=#{@bg}]#{s|-mode||:#{pane_mode}} ,}#[default],}#[default]'
    set -g @pane_border_right '#{?pane_active,#{?#{E:is_vi_keys},#{?#{E:is_any_current_keys}, #{s| ||:#{@current_keys} } ,} #{e|+|:#{E:copy_cursor_y_abs},1}:#{e|+|:#{copy_cursor_x},1} #[default],},}'
    set -g @pane_border_center '#{?pane_active,#{?#{window_zoomed_flag},#[fg=#{@bg} bg=terminal]#[bg=#{@bg} fg=#{@fg}] 󰍉 #[fg=#{@bg} bg=terminal]#[default],},}'
    set -g pane-border-style 'fg=#{@bg}'
    set -g pane-active-border-style 'fg=#{@a1}'
    set -g pane-border-format '#[align=left]#[push-default]#{E:@pane_border_left}#[default]#[pop-default]#[align=centre]#[push-default]#{E:@pane_border_center}#[default]#[pop-default]#[align=right]#[push-default]#{E:@pane_border_right}#[default]#[pop-default]'

    set -Fg cursor-color 'white' 
    set -g mode-style 'bg=#313244 bold'
    # set -g copy-mode-mark-style 'bold'
    set -g copy-mode-match-style 'bg=#313244 bold'
    set -g copy-mode-current-match-style 'bg=#717274 bold'

    set -Fg display-panes-active-color '#{@a1}'
    set -Fg display-panes-color '#{@bg}'

    set -g message-style 'fg=#{@fg} bg=#{@a1}'
    set -g message-command-style 'fg=#{@fg} bg=#{@a1}'

    set -g menu-border-lines 'none'
    set -g menu-border-style 'bg=#{@bg} fg=#{@fg}'
    set -g menu-style 'bg=#{@bg} fg=#{@fg}'
    set -g menu-selected-style 'bg=#{@a1} fg=#{@fg}'
  '');
in
{
  files = {
    ".config/tmux/tmux.conf" = config;
    ".config/tmux/helix.conf" = helixConf;
    ".config/tmux/plugins" = pluginsDrv;
  };
}
