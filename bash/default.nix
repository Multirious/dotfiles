{ config, lib, ... }:
let
  cfg = config.bash;
in
{
  options.bash.enable = lib.mkEnableOption "Enable Bash configuration";
  config = lib.mkIf cfg.enable {
    shell.enable = true;
    files = {
      ".bash_logout" = ./bash_logout;
      ".bashrc" = ./bashrc;
      ".bash_profile" = ./bash_profile;
      ".config/bash/env" = ./env;
      ".config/bash/login" = ./login;
      ".config/bash/logout" = ./logout;
      ".config/bash/interactive" = ./interactive;
    };
  };
}
