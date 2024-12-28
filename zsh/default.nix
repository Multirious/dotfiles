{ mkConfig, dontPatch, keyMappings, writeScript, fetchFromGitHub }:
let
  plugins = writeScript "dotconfig-zsh-plugins"
    (let
      zsh-helix-mode = fetchFromGitHub {
        owner = "multirious";
        repo = "zsh-helix-mode";
        rev = "a9cad782548b7204eb01e3a8f2e493e34bd48267";
        sha256 = "sha256-38FOuXI0p0IdtEn4tX9iLZUfCG9XtR7a7WbOXe/vA1k=";
      };
    in
    ''
      source ${zsh-helix-mode}/zsh-helix-mode.plugin.zsh
    '');
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
