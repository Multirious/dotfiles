{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.linuxWorkspace;
in
{
  options.myModules.linuxWorkspace.enable = lib.mkEnableOption "Enable configuration and applications for working in Linux";
  config = lib.mkIf cfg.enable {
    home.packages =
      let
        tmux = pkgs.tmux.overrideAttrs
          (finalAttrs: prevAttrs: {
            version = "865117a05fa1e850da07f67b422a469ee58fe019";
            src = pkgs.fetchFromGitHub {
              owner = "tmux";
              repo = "tmux";
              rev = "865117a05fa1e850da07f67b422a469ee58fe019";
              hash = "sha256-hjiNXGMlUC+jjPvw9a6EXUAGuHbGwRFY0cGi4/K+lak=";
            };
          });
        helix = pkgs.helix.overrideAttrs (final: prev: {
          patches = prev.patches ++ [
            ../catppuccin_mocha.patch
          ];
        });
      in [
        pkgs.kitty

        pkgs.zed-editor

        helix
        pkgs.zsh
        pkgs.starship
        tmux

        pkgs.curl
        pkgs.xz
        pkgs.zoxide
        pkgs.fzf
        pkgs.eza
        pkgs.tldr
        pkgs.file
        pkgs.direnv
        pkgs.jq
        pkgs.wget
        pkgs.btop
        pkgs.scooter
      ];
    xdg.desktopEntries.Helix = {
      name = "Helix";
      genericName = "Text Editor";
      exec = "kitty hx %F";
      comment = "Edit text files";
      type = "Application";
      icon = "helix";
      categories = [ "Utility" "TextEditor" ];
      mimeType = [
        "text/english"
        "text/markdown"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
    };
    xdg.mimeApps = {
      defaultApplications = {
        "text/plain"    = [ "Helix.desktop" ];
        "text/css"      = [ "Helix.desktop" ];
        "text/csv"      = [ "Helix.desktop" ];
        "text/html"     = [ "Helix.desktop" ];
        "text/markdown" = [ "Helix.desktop" ];
        "text/xml"      = [ "Helix.desktop" ];
      };
    };
  };
}
