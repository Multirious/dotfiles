{ config, pkgs, ... }:
{
  imports = [];

  home.username = "peach";
  home.homeDirectory = "/home/peach";

  targets.genericLinux.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = 
  with pkgs; let
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
    rust = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-analyzer" "rustfmt" "rust-src" "rust-std" "rust-src" ];
      targets = [ "x86_64-pc-windows-gnu" ];
    };
    firefox = pkgs.firefox.overrideAttrs (a:
      {
        buildCommand = a.buildCommand + ''
          wrapProgram "$executablePath" \
            --set 'HOME' '${config.home.homeDirectory}/.config'
        '';
      }
    );
    steam = pkgs.steam.override {
      extraEnv.HOME = "${config.home.homeDirectory}/.config";
    };
  in
  [
    wl-clipboard
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
    wget

    zsh
    starship
    home-manager
    nerd-fonts.hack
    keepassxc
    yt-dlp
    ffmpeg
    steam
    reaper
    firefox
    megasync
    kitty
    gephi
    lan-mouse

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

    sqlx-cli
  ];
  fonts.fontconfig.enable = true;

  home.stateVersion = "24.05";
}
