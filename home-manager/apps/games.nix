{ pkgs, ... }:
{
  home.packages = with pkgs; [
    warsow
  ];
}
