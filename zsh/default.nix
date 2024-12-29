{ mkConfig, dontPatch, keyMappings, writeScript, fetchFromGitHub }:
let
  plugins = writeScript "dotconfig-zsh-plugins"
    (let
      zsh-helix-mode = fetchFromGitHub {
        owner = "multirious";
        repo = "zsh-helix-mode";
        rev = "5f3f58b9aff8296eddc3cc9f6a3ead99b9d0bf02";
        sha256 = "sha256-36V8guzkFQpf3ryX3XnUVtoMHO0OVgm8uAhYasO4uB0=";
      };
    in
    ''
      # source ${zsh-helix-mode}/zsh-helix-mode.plugin.zsh
      # bindkey -M hins "jk" zhm_normal
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
