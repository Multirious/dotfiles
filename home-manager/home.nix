{ config, pkgs, ... }:
{
  home.username = "peach";
  home.homeDirectory = "/home/peach";

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    xclip
    nixd
    keepassxc
    helix
    tmux
    git
    zsh
    fzf
    home-manager
    starship
    (nerdfonts.override { fonts = ["Hack"]; })
    jq

    rust-analyzer
    cargo
  ];
  fonts.fontconfig.enable = true;

  home.stateVersion = "24.05";
}
