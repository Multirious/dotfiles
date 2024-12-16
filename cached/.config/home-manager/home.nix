{ config, pkgs, ... }:
{
  home.username = "peach";
  home.homeDirectory = "/home/peach";

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    xclip
    nixd
    keepassxc
    helix
    (tmux.overrideAttrs (finalAttrs: prevAttrs: {
      version = "ae8f2208c98e3c2d6e3fe4cad2281dce8fd11f31";
      src = fetchFromGitHub {
        owner = "tmux";
        repo = "tmux";
        rev = "ae8f2208c98e3c2d6e3fe4cad2281dce8fd11f31";
        hash = "sha256-RkT0BbqzSUn6vK8vmCq3r+vm6rqWDCCtxqbY8eYdL0k=";
      };
    }))
    git
    zsh
    fzf
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
    # (rust-bin.selectLatestNightlyWith
    #   (toolchain: toolchain.default.override
    #     {
    #       extensions = [ "rust-analyzer" "rustfmt" "rust-src" "rust-std" "rustc-dev" "llvm-tools" ];
    #       targets = [ "x86_64-pc-windows-gnu" ];
    #     }
    #   )
    # )
    python3
    gleam
    ghc
    go gopls
    zig zls
  ];
  fonts.fontconfig.enable = true;

  home.stateVersion = "24.05";
}
