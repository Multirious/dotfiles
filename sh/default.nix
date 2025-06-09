{ config, lib, ... }:
let
  cfg = config.sh;
in
{
  options.sh.enable = lib.mkEnableOption "Enable Bourne shell configuration";
  config = lib.mkIf cfg.enable {
    shell.enable = true;
    files = {
      ".profile" = ./.profile;
    };
  };
}
