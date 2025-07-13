{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.password;
in
{
  options.myModules.password.enable = lib.mkEnableOption "Enable password applications";
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.keepassxc
    ];
  };
}
