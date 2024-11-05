{ pkgs, ... }:
{
  attrsToKv = attrs: pkgs.lib.concatStringsSep " "
    (map
      (k: "${k}=${attrs.${k}}")
      (builtins.attrNames attrs)
    );
}
