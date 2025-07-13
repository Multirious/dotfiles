{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.mail;
in
{
  options.myModules.mail.enable = lib.mkEnableOption "Enable mail applications";
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.geary
    ];
  };
}
