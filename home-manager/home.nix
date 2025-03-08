{ config, pkgs, ... }:
{
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
    librewolf-wayland = pkgs.librewolf-wayland.overrideAttrs (a:
      {
        buildCommand = a.buildCommand + ''
          wrapProgram "$executablePath" \
            --set 'HOME' '${config.home.homeDirectory}/.local/share/librewolf'
        '';
      }
    );
    # tor-browser = pkgs.tor-browser.overrideAttrs (a:
    #   {
    #     buildCommand = a.buildCommand + ''
    #       wrapProgram "$executablePath" \
    #         --set 'HOME' '${config.home.homeDirectory}/.local/share/tor'
    #     '';
    #   }
    # );
    steam = pkgs.steam.override {
      extraEnv.HOME = "${config.home.homeDirectory}/.local/share/steam";
    };
    # lan-mouse = pkgs.lan-mouse.overrideAttrs (old: rec {
    #   pname = "lan-mouse";
    #   version = "latest";
    #   src = fetchFromGitHub {
    #     owner = "feschber";
    #     repo = "lan-mouse";
    #     rev = "latest";
    #     hash = "sha256-vh5PknQOp4mzSQSS5lChw5ZzbbfBmUPqi1vgcZ4noSI=";
    #   };
    #   cargoDeps = old.cargoDeps.overrideAttrs {
    #     inherit src;
    #     outputHash = lib.fakeHash;
    #   };
    # });
  in
  [
    wl-clipboard
    curl
    xz

    zoxide
    tmux
    fzf
    eza
    tldr
    file

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
    librewolf-wayland
    tor-browser
    megasync
    kitty
    gephi
    lan-mouse
    obs-studio
    xdg-desktop-portal-wlr
    slurp
    htop

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

    waybar
    hyprpaper
  ];
  fonts.fontconfig.enable = true;

  home.stateVersion = "24.05";
}
