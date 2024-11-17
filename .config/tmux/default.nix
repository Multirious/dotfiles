{ mkConfig, callPackage, pkgs, dontPatch ? false }:
let
  inherit (pkgs) writeText symlinkJoin;

  runPlugin = plugin:
    let
      rtp = pkgs.lib.strings.removePrefix "${plugin.out}/" plugin.rtp;
    in
    ''
      run-shell '#{d:current_file}/plugins/${rtp}'
    '';
  genModalKeyMappings = (modalKeyMappings:
    callPackage ./gen-modal-key-mappings.nix { inherit modalKeyMappings; }
  );

  plugins = with pkgs.tmuxPlugins; {
    yank = yank;
    catppuccin = catppuccin.overrideAttrs (attr: {
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "tmux";
        rev = "v2.1.0";
        hash = "sha256-kWixGC3CJiFj+YXqHRMbeShC/Tl+1phhupYAIo9bivE=";
      };
      dontPatchShebangs = dontPatch;
    });
  };
  pluginsDrv = symlinkJoin {
    name = "dotconfig-tmux-plugins";
    paths = builtins.attrValues plugins;
  } // plugins;

  modalKeyMappings = {
    v = /*bash*/''
      if-shell -F '#{!=:#{@mode},extend}' {
        set -p @mode 'extend'
      } {
        set -p @mode 'normal'
      }
    '';
    h = /*bash*/''
      send-keys -X cursor-left
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
    '';
    j = /*bash*/''
      send-keys -X cursor-down
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
    '';
    k = /*bash*/''
      send-keys -X cursor-up
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
    '';
    l = /*bash*/''
      send-keys -X cursor-right
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
    '';
    w = /*bash*/''
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      send-keys -X next-word
    '';
    e = /*bash*/''
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      send-keys -X next-word-end
    '';
    b = /*bash*/''
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      send-keys -X previous-word
    '';
    C-u = /*bash*/''
      send-keys -X halfpage-up
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
    '';
    C-d = /*bash*/''
      send-keys -X halfpage-down
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
    '';
    y = /*bash*/''
      send-keys -X copy-selection-and-cancel
      run-shell -b "tmux show-buffer | xclip -sel clip"
      set -p @selecting '''
      set -p @current_keys '''
    '';
    g = {
      g = /*bash*/''
        send-keys -X history-top
        if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      '';
      e = /*bash*/''
        send-keys -X history-bottom
        if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      '';
      h = /*bash*/''
        send-keys -X start-of-line
        if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      '';
      l = /*bash*/''
        send-keys -X end-of-line
        if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      '';
      s = /*bash*/''
        send-keys -X back-to-indentation
        if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      '';
    };
    "\\;" = /*bash*/''
      send-key -X begin-selection
    '';
    "M-\\;" = /*bash*/''
      send-key -X other-end
    '';
    "]" = {
      p = /*bash*/''
        send-key -X next-paragraph
        if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      '';
    };
    "[" = {
      p = /*bash*/''
        send-key -X previous-paragraph
        if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
      '';
    };
    m.m = /*bash*/''
      send-key -X next-matching-bracket
      if-shell -F '#{!=:#{@mode},extend}' "send-key -X begin-selection"
    '';
  };
  config = writeText "dotconfig-tmuxconf" /*bash*/''
    set -sa terminal-overrides ",xterm*:Tc"
    set -g status-position top
    set -g set-clipboard on
    set -g base-index 1

    setw -g mode-keys vi

    unbind '%'
    unbind '"'
    unbind [
    unbind z
    unbind -T copy-mode-vi -a

    bind -n C-h select-pane -L
    bind -n C-j select-pane -D 
    bind -n C-k select-pane -U
    bind -n C-l select-pane -R

    bind -n M-H resize-pane -L 5
    bind -n M-J resize-pane -D 5
    bind -n M-K resize-pane -U 5
    bind -n M-L resize-pane -R 5

    bind -n M-h previous-window
    bind -n M-l next-window

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

    bind -T copy-mode-vi / command-prompt -T search -p "search:" {
      set -up @mode
      set -up @current_keys
      send -X clear-selection
      send -X search-forward "%%"
    }
    bind -T copy-mode-vi ? command-prompt -T search -p "search:" {
      set -up @mode
      set -up @current_keys
      send -X clear-selection
      send -X search-backward "%%"
    }
    bind -T copy-mode-vi n {
      set -up @mode
      set -up @current_keys
      send -X clear-selection
      send -X search-again
    }
    bind -T copy-mode-vi N {
      set -up @mode
      set -up @current_keys
      send -X clear-selection
      send -X search-reverse
    }

    ${genModalKeyMappings modalKeyMappings}

    bind -n M-c set -up @mode \; set -up @current_keys \; copy-mode
    bind -T copy-mode-vi M-c send -X cancel
    bind -T copy-mode-vi C-c send -X cancel
    bind -T copy-mode-vi Escape set -up @current_keys \; set -up @mode

    ${runPlugin plugins.yank}

    set -g @catppuccin_flavor 'mocha'

    set -g @catppuccin_status_background 'default'
    set -g @catppuccin_window_status_style "rounded"

    set -g @catppuccin_window_current_text " #W"
    set -g @catppuccin_window_default_text " #W"
    ${runPlugin plugins.catppuccin}
  '';
in
mkConfig {
  name = "dotconfig-tmux";
  files = {
    "tmux.conf" = "${config}";
    "plugins" = "${pluginsDrv}";
  };
}
