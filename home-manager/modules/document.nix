{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.document;
in
{
  options.myModules.document.enable = lib.mkEnableOption "Enable applications for working with documents";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice
    ];
    xdg.mimeApps = {
      defaultApplications = {
        "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ];
      };
    };
  };
}
