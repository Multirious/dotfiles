{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.browser;
in
{
  options.myModules.browser.enable = lib.mkEnableOption "Enable browser applications";
  config = lib.mkIf cfg.enable {
    home.packages = 
      let
        librewolf-wayland = pkgs.librewolf-wayland.overrideAttrs (a:
          {
            buildCommand = a.buildCommand + ''
              wrapProgram "$executablePath" \
                --set 'HOME' '${config.home.homeDirectory}/.local/share/librewolf'
            '';
          }
        );
        tor-browser = (import (builtins.fetchGit {
          name = "nixpkgs-with-tor-browser-v14.0.9";
          url = "https://github.com/NixOS/nixpkgs/";
          ref = "refs/heads/nixpkgs-unstable";
          rev = "7d7ba194bf834a5194dadfa8f9debcfabaa718bb";
        }) {
          inherit (pkgs) system;
        }).tor-browser;
      in
      [
        tor-browser
        librewolf-wayland 
        pkgs.google-chrome
      ];
    xdg.mimeApps = {
      defaultApplications = {
        "text/html"       = [ "librewolf.desktop" ];
        "x-scheme-handler/http"    = [ "librewolf.desktop" ];
        "x-scheme-handler/https"   = [ "librewolf.desktop" ];
        "x-scheme-handler/about"   = [ "librewolf.desktop" ];
        "x-scheme-handler/unknown" = [ "librewolf.desktop" ];
      };
    };
  };
}
