{ config, pkgs, ... }:
{
  home.packages = with pkgs;
  let
    steam = pkgs.steam.override {
      extraEnv.HOME = "${config.home.homeDirectory}/.local/share/steam";
    };
  in
  [
    yt-dlp
    keepassxc
    steam
    reaper
    megasync
    discord
    libsForQt5.dolphin
    lan-mouse
    blender
    vlc
    zip
    unzip
    rar
    steam-run
    p7zip
    udiskie
  ];
}
