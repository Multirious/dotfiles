{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.ha;
in
{
  options.myModules.ha.enable = lib.mkEnableOption "Enable";
  config = lib.mkIf cfg.enable {
    home.packages = [];
  };
}
