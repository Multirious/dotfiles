{ pkgs }:
let
  names = {
    ".bash_logout" = ./.bash_logout;
    ".bashrc" = ./.bashrc;
    ".bash_profile" = ./.bash_profile;
    ".profile" = ./.profile;
    ".zshenv" = ./.zshenv;
    ".zshrc" = ./.zshrc;

    ".config/shell" = ./.config/shell;
    ".config/sh" = ./.config/sh;
    ".config/zsh" = ./.config/zsh;
    ".config/bash" = ./.config/bash;

    ".config/home-manager" = ./.config/home-manager;

    ".config/tmux" = pkgs.callPackage ./.config/tmux {};
    ".config/helix" = pkgs.callPackage ./.config/helix {};
    ".config/git" = pkgs.callPackage ./.config/git {};
  };
in
derivation {
  name = "files";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./files.sh ];
  coreutils = pkgs.coreutils;
  system = builtins.currentSystem;
  paths = pkgs.lib.attrsToKv names;
} // {
  inherit names;
}
