{ lib, plugins, ... }:
with lib;
let
  pluginName = p: if types.package.check p then p.pname else p.plugin.pname;
  pluginRtp = p: if types.package.check p then p.rtp else p.plugin.rtp;
in
''
  ${
    concatMapStringsSep
      "\n\n"
      (p: ''
        # ${pluginName p}
        # ---------------------
        ${p.config or ""}
        run-shell ${pluginRtp p}''
      )
      plugins
  }
  # ============================================= #
''
