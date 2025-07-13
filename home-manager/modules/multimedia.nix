{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.multimedia;
in
{
  options.myModules.multimedia.enable = lib.mkEnableOption "Enable images, video, and audio applications";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nomacs
      vlc
      ffmpeg
      yt-dlp
      qpwgraph
    ];
    xdg.mimeApps = {
      defaultApplications = {
        "audio/mpeg"      = [ "vlc.desktop"       ];
        "audio/ogg"       = [ "vlc.desktop"       ];
        "audio/wav"       = [ "vlc.desktop"       ];
        "audio/webm"      = [ "vlc.desktop"       ];
        "video/mpeg"      = [ "vlc.desktop"       ];
        "video/ogg"       = [ "vlc.desktop"       ];
        "video/webm"      = [ "vlc.desktop"       ];
      };
    };
  };
}
