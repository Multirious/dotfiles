{ ... }:
{
  imports = [
    ../desktop-environment/hyprland.nix
    ../applications/browsers.nix
    ../applications/development.nix
    ../applications/personal.nix
    ../applications/preferred.nix
    ../applications/sixel.nix
    ../applications/terminal-emulator.nix
    ../applications/tools.nix
  ];
  home.username = "peach";
  home.homeDirectory = "/home/peach";
}
