{ config, pkgs, ... }:
{
  home.username = "peach";
  home.homeDirectory = "/home/peach";

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    curl
    xz
    xclip
    nixd
    keepassxc
    helix
    (tmux.overrideAttrs (finalAttrs: prevAttrs: {
      version = "00894d188d2a60767a80ae749e7c3fc810fca8cd";
      src = fetchFromGitHub {
        owner = "tmux";
        repo = "tmux";
        rev = "00894d188d2a60767a80ae749e7c3fc810fca8cd";
        hash = "sha256-aMXYBMmcRap8Q28K/8/2+WTnPxcF7MTu1Tr85t+zliU=";
      };
    }))
    git
    zsh
    fzf
    eza
    home-manager
    starship
    nerd-fonts.hack
    jq
    neofetch
    direnv
    zoxide
    evcxr
    lsix
    libsixel
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-analyzer" "rustfmt" "rust-src" "rust-std" "rust-src" ];
      targets = [ "x86_64-pc-windows-gnu" ];
    })
    python3
    gleam
    ghc
    go gopls
    zig zls
    gcc
  ];
  fonts.fontconfig.enable = true;

  home.stateVersion = "24.05";
}
