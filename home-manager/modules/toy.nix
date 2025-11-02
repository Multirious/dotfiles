{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.toy;
in
{
  options.myModules.toy.enable = lib.mkEnableOption "Enable toy programs";
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fastfetch
    ];
  };
}

