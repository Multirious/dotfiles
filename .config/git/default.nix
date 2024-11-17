{ mkConfig, pkgs, dontPatch ? false }:
let
  gitk = ./gitk;
  config = ./config;
in
mkConfig {
  name = "dotconfig-git";
  files = {
    inherit config;
    inherit gitk;
  };
}
