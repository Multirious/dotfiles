{ config, lib, ... }:
let
  cfg = config.shell;
in
{
  options.shell.enable = lib.mkEnableOption "Enable generic shell configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/shell/env" = ./env;
    ".config/shell/login" = ./login;
    ".config/shell/logout" = ./logout;
    ".config/shell/interactive" = ./interactive;
    ".config/shell/tmux_functions" = ./tmux_functions;
    ".config/shell/env_functions" = ./env_functions;
    ".config/shell/nix_functions" = ./nix_functions;
    ".config/shell/de_functions" = ./de_functions;
  };
}
