{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.audioWorkspace;
in
{
  options.myModules.audioWorkspace.enable = lib.mkEnableOption "Enable audio and music making applications";
  config = lib.mkIf cfg.enable{
    home.file.".local/share/vst3/Vital.vst3".source = "${pkgs.vital}/lib/vst3/Vital.vst3";
    home.file.".local/share/vst/Vital.so".source = "${pkgs.vital}/lib/vst/Vital.so";
    home.file.".local/share/clap/Vital.clap".source = "${pkgs.vital}/lib/clap/Vital.clap";
    home.packages = with pkgs; [
      reaper
      openutau
      ffmpeg
      vlc
    ];
  };
}
