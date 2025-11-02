{ pkgs ? import <nixpkgs> {} }: 
let
  dotfiles = (pkgs.callPackage ./lib/dotfiles.nix {}).dotfiles;
in
dotfiles [
  ./bash
  ./config.nix
  ./git
  ./helix
  ./home-manager
  ./hypr
  ./kitty
  ./mako
  ./misc
  ./scripts
  ./sh
  ./shell
  ./starship
  ./sway
  ./swaylock-effects
  ./tmux
  ./waybar
  ./wofi
  ./zsh
]
