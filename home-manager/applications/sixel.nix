{ pkgs, ... }:
{
  home.packages = [
    pkgs.lsix
    pkgs.libsixel
  ];
}
