{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.linuxWorkspace;
in
{
  options.myModules.linuxWorkspace.enable = lib.mkEnableOption "Enable configuration and applications for working in Linux";
  config = lib.mkIf cfg.enable {
    home.packages =
      let
        tmux = pkgs.tmux.overrideAttrs
          (finalAttrs: prevAttrs: {
            version = "d3c39375d5e9f4a0dcb5bd210c912d70ceca5de9";
            src = pkgs.fetchFromGitHub {
              owner = "tmux";
              repo = "tmux";
              rev = "d3c39375d5e9f4a0dcb5bd210c912d70ceca5de9";
              hash = "sha256-CTo6NJTuS2m5W6WyqTHg4G6NiRqt874pFGvVgmbKeC8=";
            };
          });
      in [
        pkgs.kitty

        pkgs.helix
        pkgs.zsh
        pkgs.starship
        tmux

        pkgs.curl
        pkgs.xz
        pkgs.zoxide
        pkgs.fzf
        pkgs.eza
        pkgs.tldr
        pkgs.file
        pkgs.direnv
        pkgs.jq
        pkgs.wget
        pkgs.btop
        pkgs.scooter
      ];
  };
}
