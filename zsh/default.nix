{ mkConfig, callPackage, dontPatch, keyMappings, writeScript }:
let
  inherit (callPackage ./helix-key-mapper.nix {}) mapZshHelixKeys; 
  helixKeyMappings = writeScript
  "dotconfig-zsh-helix"
  ''
    ${mapZshHelixKeys keyMappings}
  '';
in
mkConfig {
  name = "dotconfig-zsh";
  files = {
    "env" = ./env;
    "login" = ./login;
    "logout" = ./logout;
    "interactive" = ./interactive;
    "completion.zsh" = ./completion.zsh;
    "dirs.zsh" = ./dirs.zsh;
    "helix.zsh" = "${helixKeyMappings}";
  };
}
