{ config, lib, ... }:
let
  cfg = config.scripts;
in
{
  options.scripts.enable = lib.mkEnableOption "Enable user scripts";
  config.files = lib.mkIf cfg.enable {
    "scripts/debug-derivative" = ./debug-derivative;
  };
}

