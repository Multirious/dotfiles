{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.image;
in
{
  options.myModules.image.enable = lib.mkEnableOption "Enable applications for relate to images";
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gimp
    ];
  };
}
