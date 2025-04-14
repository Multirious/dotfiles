{ pkgs, ... }:
{
  home.packages = [ pkgs.home-manager ];
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "24.05";
}
