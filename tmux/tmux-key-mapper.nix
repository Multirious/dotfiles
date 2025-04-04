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
