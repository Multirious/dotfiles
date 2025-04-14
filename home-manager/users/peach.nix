{ ... }:
{
  imports = [
    ../de/hyprland.nix
    ../apps/browsers.nix
    ../apps/personal.nix
    ../apps/preferred.nix
    ../apps/sixel.nix
    ../apps/terminal-emulator.nix
    ../apps/tools.nix
    ../apps/nix.nix
    ../theme/cursor.nix
  ];
  home.username = "peach";
  home.homeDirectory = "/home/peach";
}
