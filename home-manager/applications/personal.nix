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
  ];
}
