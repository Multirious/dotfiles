{ pkgs, mkConfig, dontPatch, keyMappings, writeScript, callPackage }:
let
  plugins = writeScript "dotconfig-zsh-plugins" (callPackage ./plugins.nix {});
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
    "plugins.zsh" = "${plugins}";
  };
}
