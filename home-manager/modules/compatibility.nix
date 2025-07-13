{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.compatibility;
in
{
  options.myModules.compatibility.enable = lib.mkEnableOption "Enable applications allowing compatibility with the system";
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.steam-run
      pkgs.bottles
    ];
  };
}
