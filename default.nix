{ pkgs ? import <nixpkgs> {} }: 
let
  dotfiles = (pkgs.callPackage ./lib/dotfiles.nix {}).dotfiles;
in
dotfiles [
  ./bash
  ./helix
  ./shell
  ./tmux
  ./git
  ./home-manager
  ./sh
  ./starship
  ./zsh
  ./kitty
  ./sway
  ./swaylock-effects
  ./waybar
  ./misc
  ./hypr
  ./mako
]
