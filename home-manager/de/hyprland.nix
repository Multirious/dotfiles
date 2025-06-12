{ pkgs, externalPkgs, ... }:
let
  Hyprspace = externalPkgs.Hyprspace.packages.${pkgs.system}.Hyprspace;
  hypr-dynamic-cursors = externalPkgs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors;
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
    mako
    hyprpolkitagent
  ];
  home.file.".local/state/hyprland/plugins.conf".text = ''
    # plugin = ${Hyprspace}/lib/lib${Hyprspace.pname}.so
    # plugin = ${hypr-dynamic-cursors}/lib/libhypr-dynamic-cursors.so
  '';
}
