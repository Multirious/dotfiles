{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.university;
in
{
  options.myModules.university.enable = lib.mkEnableOption "Enable University related configurations and applications";
  config = lib.mkIf cfg.enable {
    myModules.browser.enable = true;
    home.packages = [
      (pkgs.writeTextFile {
        name = "libre-wolf-university.desktop";
        destination = "/share/applications/librewolf-university.desktop";
        text = ''
          [Desktop Entry]
          Categories=Network;WebBrowser
          Exec=librewolf -p University
          GenericName=University Web Brwoser
          Icon=librewolf
          MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;x-scheme-handler/http;x-scheme-handler/https
          Name=LibreWolf University
          StartupNotify=true
          StartupWMClass=librewolf
          Terminal=false
          Type=Application
          Version=1.4
        '';
      })
    ];
  };
}

