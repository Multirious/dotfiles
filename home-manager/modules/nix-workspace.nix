{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.nixWorkspace;
in
{
  options.myModules.nixWorkspace.enable = lib.mkEnableOption "Enable configurations and applications for working with Nix";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nixd
      pkgs.nixfmt-rfc-style
    ];
    programs.nix-index.enable = true;
    programs.nix-index.enableBashIntegration = false;
    programs.nix-index.enableZshIntegration = false;
  };
}
