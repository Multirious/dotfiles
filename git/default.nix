{ config, pkgs, lib, ... }:
let
  cfg = config.git;
in
let
  inherit (pkgs) writeText;
  draculaTheme = pkgs.fetchgit {
    url = "https://github.com/dracula/gitk";
    hash = "sha256-l0+GVEGSri4A6S4tanW03pT94ilT5a8qAPbzrOQXFEw=";
  };
  gitk = writeText "dotfiles-gtk" ''
    ${builtins.readFile ./gitk}
    ${builtins.readFile "${draculaTheme}/gitk"}
  '';
in
{
  options.git.enable = lib.mkEnableOption "Enable Git configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/git/gitk" = gitk;
    ".config/git/config" = ./config;
  };
}
