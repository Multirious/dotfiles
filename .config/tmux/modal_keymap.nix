{ pkgs, keymap }:
let
  inherit (pkgs) lib;
  attrsRec = set:
    lib.lists.foldl
    (res: attr:
      res // (
      if builtins.isAttrs set."${attr}"
       then attrsRec set."${attr}" // { "${attr}" = null; }
       else { "${attr}" = null; } 
      )
    )
    {}
    (builtins.attrNames set);
  _attrsPath = path: set:
      lib.lists.foldl
      (list: key:
        list ++ (if builtins.isAttrs set."${key}"
          then _attrsPath "${path} ${key}" set."${key}"
          else [{
            name = "${path} ${key}";
            value = set."${key}";
          }]
        )
      )
      []
      (builtins.attrNames set)
    ;
  attrsPath = set:
    builtins.listToAttrs (_attrsPath "" set);
  keyPaths = attrsPath keymap;
  keys = attrsRec keymap;
  keyBinds = builtins.listToAttrs (
    map
    (key: {
      name = key;
      value = builtins.listToAttrs (
        map
        (keyPath: {
          name = keyPath;
          value = keyPaths."${keyPath}";
        })
        (
          builtins.filter
          (path: lib.strings.hasSuffix key path)
          (builtins.attrNames keyPaths)
        )
      );
    })
    (builtins.attrNames keys)
  );
  fixIndent = string:
    builtins.replaceStrings ["\n"] ["\n  "] (lib.trim string);
  keybindTexts = map
    (key: ''
      bind-key -T copy-mode-vi ${key} {
        set-option -Fp @current_keys '#{@current_keys} ${key}'
        ${lib.concatMapStringsSep
          "\n  "
          (path:
            let
              value = keyBinds."${key}"."${path}";
            in
            fixIndent
            ''
              if-shell -F '#{==:"#{@current_keys}","${path}"}' {
                ${fixIndent value}
                set-option -p @current_keys '''
              }
            ''
          )
          (builtins.attrNames keyBinds."${key}")
        }
      }
    '')
    (builtins.attrNames keyBinds);
in
/*bash*/''
set-option -g @mode 'normal'
set-option -g @current_keys '''
${ lib.concatStrings keybindTexts }
''
