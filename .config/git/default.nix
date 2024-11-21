{ mkConfig, pkgs, dontPatch ? false }:
let
  inherit (pkgs) writeText;
  draculaTheme = pkgs.fetchgit {
    url = "https://github.com/dracula/gitk";
    hash = "sha256-l0+GVEGSri4A6S4tanW03pT94ilT5a8qAPbzrOQXFEw=";
  };
  gitk = writeText "dotconfig-git-gitk" ''
    ${builtins.readFile ./gitk}
    ${builtins.readFile "${draculaTheme}/gitk"}
  '';
  config = ./config;
in
mkConfig {
  name = "dotconfig-git";
  files = {
    inherit config;
    gitk = "${gitk}";
  };
}
