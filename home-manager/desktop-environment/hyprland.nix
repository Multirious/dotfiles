{ pkgs, externalPkgs, ... }:
let
  Hyprspace = externalPkgs.Hyprspace.packages.${pkgs.system}.Hyprspace;
in
{
  home.packages = with pkgs;
  [
    wl-clipboard
    wofi
    waybar
    hyprpaper
    swaylock-effects
    hypridle
    Hyprspace
  ];
  home.file.".local/share/hyprplugins".text = ''
    plugin = ${Hyprspace}/lib/lib${Hyprspace.pname}.so
  '';
}
