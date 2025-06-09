{ pkgs, writeText, ... }:
{
  config.files = {
    # ".config/sway/config" = writeText "dotfiles-sway" ''
    #   ${builtins.readFile ./config}
    #   exec --no-startup-id ${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr -r
    # '';
    ".config/sway/config" = ./config;
  };
}
