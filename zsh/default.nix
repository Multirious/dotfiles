{ config, pkgs, lib, ... }:
let
  cfg = config.zsh;
  inherit (pkgs) writeScript callPackage;
in
{
  options.zsh.enable = lib.mkEnableOption "Enable Zsh configuration";
  config = lib.mkIf cfg.enable {
    shell.enable = true;
    files = {
      ".zshenv" = ./zshenv;
      ".zshrc" = ./zshrc;
      ".zprofile" = ./zprofile;
      ".config/zsh/env" = ./env;
      ".config/zsh/login" = ./login;
      ".config/zsh/logout" = ./logout;
      ".config/zsh/interactive" = ./interactive;
      ".config/zsh/completion.zsh" = ./completion.zsh;
      ".config/zsh/plugins.zsh" = writeScript "zsh-plugins" (callPackage ./plugins.nix {});
    };
  };
}
