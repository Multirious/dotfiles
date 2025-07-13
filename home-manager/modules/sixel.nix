{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.sixel;
in
{
  options.myModules.sixel.enable = lib.mkEnableOption "Enable Sixel support";
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.lsix
      pkgs.libsixel
    ];
  };
}
