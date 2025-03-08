{ pkgs, ... }:
{
  home.packages = with pkgs;
  let
    tmux = pkgs.tmux.overrideAttrs (finalAttrs: prevAttrs:
      {
        version = "9a377485becdd34dda695f38cb73ee5082d9088b";
        src = fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = "9a377485becdd34dda695f38cb73ee5082d9088b";
          hash = "sha256-WLcV5ybiZCs+CBCIXUUDRf6YuNOFsiCL0WDLZmlR/5U=";
        };
      });
  in
  [
    helix
    tmux
    zsh
    starship
  ];
}
