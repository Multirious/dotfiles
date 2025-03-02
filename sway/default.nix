{ pkgs, writeText }:
{
  files = {
    ".config/sway/config" = writeText "dotfiles-sway" ''
      ${builtins.readFile ./config}
      exec --no-startup-id ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal -r
    '';
  };
}
