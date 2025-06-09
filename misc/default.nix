{ config, lib, ... }:
{
  options.user-dirs.enable = lib.mkEnableOption "Enable user-dirs configuration";
  config.files = lib.mkIf config.user-dirs.enable {
    ".config/user-dirs.dirs" = ./user-dirs.dirs;
  };
}
