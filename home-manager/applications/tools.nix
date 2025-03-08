{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    xz
    zoxide
    fzf
    eza
    tldr
    file
    direnv
    jq
    wget
    ffmpeg
    htop
  ];
}
