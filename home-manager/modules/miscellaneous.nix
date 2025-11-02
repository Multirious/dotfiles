{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.miscellaneous;
in
{
  options.myModules.miscellaneous.enable = lib.mkEnableOption "Enable miscellaneous applications";
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ncdu
      pkgs.calibre
      pkgs.hwinfo
    ];
  };
}
