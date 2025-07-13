{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.modelingWorkspace;
in
{
  options.myModules.modelingWorkspace.enable = lib.mkEnableOption "Enable configurations and applications for working with 3D models";
  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.blender.override {
        cudaSupport = true;
      })
    ];
  };
}
