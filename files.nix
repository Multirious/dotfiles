{ pkgs, dontPatch ? false }:
let
  names = {
    ".bash_logout" = ./.bash_logout;
    ".bashrc" = ./.bashrc;
    ".bash_profile" = ./.bash_profile;
    ".profile" = ./.profile;
    ".zshenv" = ./.zshenv;
    ".zshrc" = ./.zshrc;
    ".zprofile" = ./.zprofile;

    ".config/shell" = ./.config/shell;
    ".config/sh" = ./.config/sh;
    ".config/zsh" = ./.config/zsh;
    ".config/bash" = ./.config/bash;

    ".config/home-manager" = ./.config/home-manager;
    ".config/starship.toml" = ./.config/starship.toml;

    ".config/tmux" = pkgs.callPackage ./.config/tmux { inherit dontPatch; };
    ".config/helix" = pkgs.callPackage ./.config/helix { inherit dontPatch; };
    ".config/git" = pkgs.callPackage ./.config/git { inherit dontPatch; };
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
