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
in
{
  files = {
    ".config/tmux/tmux.conf" = ./tmux.conf;
    ".config/tmux/helix.conf" = helixConf;
    ".config/tmux/plugins" = pluginsDrv;
  };
}
