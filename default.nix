{
  pkgs ? import <nixpkgs> {
    overlays = [
      (final: prev:
        let
          mylib = prev.callPackage ./lib {};
          keyMappings = import ./keyMappings;
        in
        {
          inherit (mylib) mkConfig mkDotfiles mkFiles;
          inherit keyMappings;
        }
      )
    ];
    config = {};
  },
}: 
let
  inherit (pkgs) callPackage mkDotfiles mkFiles;
in
mkDotfiles ({ dontPatch }:
  mkFiles {
    ".bash_logout" = ./.bash_logout;
    ".bashrc" = ./.bashrc;
    ".bash_profile" = ./.bash_profile;
    ".profile" = ./.profile;
    ".zshenv" = ./.zshenv;
    ".zshrc" = ./.zshrc;
    ".zprofile" = ./.zprofile;

    ".config/shell" = ./shell;
    ".config/sh" = ./sh;
    ".config/zsh" = callPackage ./zsh { inherit dontPatch; };
    ".config/bash" = ./bash;

    ".config/home-manager" = ./home-manager;
    ".config/starship.toml" = ./starship.toml;

    ".config/tmux" = callPackage ./tmux { inherit dontPatch; };
    ".config/helix" = callPackage ./helix { inherit dontPatch; };
    ".config/git" = callPackage ./git { inherit dontPatch; };
  }
)
