{ config, pkgs, ... }:
{
  home.username = "peach";
  home.homeDirectory = "/home/peach";

  targets.genericLinux.enable = true;

  home.packages = 
  with pkgs; let
    tmux = pkgs.tmux.overrideAttrs (finalAttrs: prevAttrs:
      {
        version = "00894d188d2a60767a80ae749e7c3fc810fca8cd";
        src = fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = "00894d188d2a60767a80ae749e7c3fc810fca8cd";
          hash = "sha256-aMXYBMmcRap8Q28K/8/2+WTnPxcF7MTu1Tr85t+zliU=";
        };
      });
    rust = pkgs.rust-bin.stable.latest.default.override
      {
        extensions = [ "rust-analyzer" "rustfmt" "rust-src" "rust-std" "rust-src" ];
        targets = [ "x86_64-pc-windows-gnu" ];
      };
  in
  [
    xclip
    curl
    xz

    zoxide
    tmux
    fzf
    eza

    helix
    git
    direnv
    jq
    gcc

    zsh
    starship
    home-manager
    nerd-fonts.hack
    keepassxc
    yt-dlp
    ffmpeg

    neofetch

    lsix
    libsixel

    nixd
    rust
    python3
    gleam
    ghc
    go gopls
    zig zls
  ];
  fonts.fontconfig.enable = true;

  home.stateVersion = "24.05";
}
