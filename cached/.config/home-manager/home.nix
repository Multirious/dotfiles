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
    nerd-fonts.hack
    jq
    neofetch
    direnv
    zoxide

    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-analyzer" "rustfmt" "rust-src" "rust-std" ];
      targets = [ "x86_64-pc-windows-gnu" ];
    })
    python3
    gleam
    ghc
    go gopls
    zig zls
  ];
  fonts.fontconfig.enable = true;

  home.stateVersion = "24.05";
}
