{ pkgs, modalKeyMappings }:
let
  inherit (pkgs) lib;
  inherit (lib.attrsets)
    nameValuePair foldlAttrs mapAttrs
    mapAttrs' filterAttrs mapAttrsToList
    mapAttrsRecursive;

  debug = v: builtins.trace (builtins.toJSON v) v;

  extraVar =''
    %hidden copy_cursor_y_abs='#{e|-|:#{e|+|:#{history_size},#{copy_cursor_y}},#{scroll_position}}'
    %hidden selection_latest_x='#{?#{>:#{selection_start_y},#{selection_end_y}},#{selection_start_x},#{?#{<:#{selection_start_y},#{selection_end_y}},#{selection_end_x},#{?#{>:#{selection_start_x},#{selection_end_x}},#{selection_start_x},#{selection_end_x}}}}'
    %hidden selection_latest_y='#{?#{>:#{selection_start_y},#{selection_end_y}},#{selection_start_y},#{selection_end_y}}'
    %hidden selection_forward='#{&&:#{==:#{copy_cursor_x},#{E:selection_latest_x}},#{==:#{E:copy_cursor_y_abs},#{E:selection_latest_y}}}'
    %hidden selection_height='#{?#{>:#{selection_start_y},#{selection_end_y}},#{e|-|:#{selection_start_y},#{selection_end_y}},#{e|-|:#{selection_end_y},#{selection_start_y}}}'
    %hidden selection_oneline='#{==:#{selection_start_y},#{selection_end_y}}'
  '';

  actions = {
    select_mode = /*bash*/''
      if -F '#{!=:#{@mode},extend}' {
        set -p @mode 'extend'
      } {
        set -p @mode 'normal'
      }
    '';
    move_left = /*bash*/''
      send -X cursor-left
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    move_down = /*bash*/''
      send -X cursor-down
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    move_up = /*bash*/''
      send -X cursor-up
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    move_right = /*bash*/''
      send -X cursor-right
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    move_next_word_start = /*bash*/''
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      send -X next-word
    '';
    move_prev_word_start = /*bash*/''
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      send -X previous-word
    '';
    move_next_word_end = /*bash*/''
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
      send -X next-word-end
    '';
    # "move_next_long_word_start" = 
    # "move_prev_long_word_start" = 
    # "move_next_long_word_end" = 
    cursor_half_page_up = /*bash*/''
      send -X halfpage-up
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    cursor_half_page_down = /*bash*/''
      send -X halfpage-down
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    yank = /*bash*/''
      send -X copy-selection-and-cancel
      run -b "tmux show-buffer | xclip -sel clip"
    '';
    extend_line_below = /*bash*/''
      ${extraVar}
      if -F '#{E:selection_forward}' {
        send -X other-end
      } 
      send -X start-of-line
      send -X other-end
      send -X cursor-right
      send -X end-of-line
    '';
    extend_to_line_bounds = /*bash*/''
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
    shrink_to_line_bounds = /*bash*/''
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
    goto_start = /*bash*/''
      send -X history-top
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    goto_end = /*bash*/''
      send -X history-bottom
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    goto_line_start = /*bash*/''
      send -X start-of-line
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    goto_line_end = /*bash*/''
      send -X end-of-line
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    goto_line_first_nonwhitespace = /*bash*/''
      send -X back-to-indentation
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    collapse_selections = /*bash*/''
      send -X begin-selection
    '';
    flip_selections = /*bash*/''
      send -X other-end
    '';
    ensure_selections_forward = /*bash*/''
      ${extraVar}
      if -F '#{!=:#{E:selection_forward},1}' {
        send -X other-end
      }
    '';
    goto_next_paragraph = /*bash*/''
      send -X next-paragraph
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    goto_prev_paragraph = /*bash*/''
      send -X previous-paragraph
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    match_brackets = /*bash*/''
      send -X next-matching-bracket
      if -F '#{!=:#{@mode},extend}' "send -X begin-selection"
    '';
    search = /*bash*/''
      command-prompt -T search -p "search:" {
        set -up @mode
        set -up @current_keys
        send -X clear-selection
        send -X search-forward "%%"
      }
    '';
    rsearch = /*bash*/''
      command-prompt -T search -p "search:" {
        set -up @mode
        set -up @current_keys
        send -X clear-selection
        send -X search-backward "%%"
      }
    '';
    search_next = /*bash*/''
      set -up @mode
      set -up @current_keys
      send -X clear-selection
      send -X search-again
    '';
    search_prev = /*bash*/''
      set -up @mode
      set -up @current_keys
      send -X clear-selection
      send -X search-reverse
    '';
    # "search_selection" = 
  };

  keyMappingActions = mapAttrsRecursive
    (path: action:
      actions."${action}" ? null
    )
    modalKeyMappings;

  escapeFormat = s:
    builtins.replaceStrings
    [ "#" "," ]
    [ "##" "#," ]
    s;

  # Merge all attributes into the same set recursively
  # {
  #   a = "1";
  #   b = {
  #     c = "2";
  #     d = "3";
  #   };
  #   c = "4";
  # {
  #
  # Into
  #
  # {
  #   a = null;
  #   b = null;
  #   c = null;
  #   d = null;
  # }
  attrsRec = set:
    foldlAttrs
    (acc: name: value:
      acc // (
        if builtins.isAttrs value
        then (attrsRec value) // { "${name}" = null; }
        else { "${name}" = null; }
      )
    )
    {}
    set;

  # Convert nested attributes into space seperated path
  # {
  #   a = "1";
  #   b = {
  #     c = "2";
  #     d = "3";
  #   };
  #   c = "4";
  # {
  #
  # Into
  #
  # {
  #   " a" = "1";
  #   " b c" = "2";
  #   " b d" = "3";
  #   " c" = "4";
  # }
  _attrsPath = path: set:
      foldlAttrs
      (acc: name: value:
        let currPath = "${path} ${name}";
        in
        acc // (
          if builtins.isAttrs value
          then _attrsPath currPath value
          else { "${currPath}" = value; }
        )
      )
      {}
      set;
  attrsPath = set: _attrsPath "" set;

  _enumSubpaths = path:
    lib.lists.foldl
    (acc: c:
      let curr = "${acc.curr} ${c}";
      in
      {
        inherit curr;
        enumerated = acc.enumerated ++ [ curr ];
      }
    )
    { curr = ""; enumerated = []; }
    (builtins.filter
      (s: s != "")
      (lib.strings.splitString " " path)
    );
  enumSubpaths = path: (_enumSubpaths path).enumerated;
  enumSubpathsMany = paths:
    lib.lists.unique
    (lib.lists.foldl
      (acc: path:
        acc ++ (enumSubpaths path)
      )
      []
      paths
    );

  pathMappings = attrsPath modalKeyMappings;
  keys = attrsRec modalKeyMappings;
  keyPathMappings = 
    mapAttrs
    (key: value:
      filterAttrs
        (path: mapping: lib.strings.hasSuffix key path)
        pathMappings
    )
    keys;
  indented = string:
    builtins.replaceStrings ["\n"] ["\n  "] (lib.trim string);
  allSubpaths = enumSubpathsMany (builtins.attrNames pathMappings);
  keyBindings =
    lib.strings.concatStrings
    (mapAttrsToList
      (keyRoot: pathMappings:
      let
        mappingChecks = mapAttrsToList
          (path: mapping: ''
            if-shell -F '#{==:#{@current_keys},${escapeFormat path}}' {
              ${indented mapping}
              set-option -up @current_keys
          '')
          pathMappings;
        modeChecks =
          builtins.filter
          (path: lib.strings.hasSuffix keyRoot path)
          allSubpaths;
        modeChecksRegex = 
          lib.strings.concatStringsSep "|"
          (map
            (path: "^${escapeFormat (lib.strings.escapeRegex path)}$")
            modeChecks
          );
      in
      ''
        bind-key -T copy-mode-vi ${keyRoot} {
          set-option -Fp @current_keys '#{@current_keys} ${keyRoot}'
          ${lib.strings.concatMapStringsSep
            "\n  } { "
            (s: indented (indented s))
            mappingChecks
          }
          ${ if builtins.length mappingChecks > 0 then "} { " else "" }if-shell -F '#{!=:#{m|r:${modeChecksRegex},#{@current_keys}},1}' {
            set-option -up @current_keys
          }${lib.concatStrings (lib.replicate (builtins.length mappingChecks) "}")}
        }
      '')
      keyPathMappings
    );
in
/*bash*/''
set-option -g @mode 'normal'
set-option -g @current_keys '''
set-hook -ag after-copy-mode {
  set-option -up @mode
  set-option -up @current_keys
}
${ keyBindings }
''
