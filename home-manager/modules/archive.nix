{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.archive;
in
{
  options.myModules.archive.enable = lib.mkEnableOption "Enable applications for working with compressed archive formats";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zip
      unzip
      rar
      p7zip
    ];
  };
}
