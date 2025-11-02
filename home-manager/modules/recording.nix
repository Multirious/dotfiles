{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.recording;
in
{
  options.myModules.recording.enable = lib.mkEnableOption "Enable recording applications";
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.obs-studio
    ];
  };
}
