{ pkgs, ... }:
{
  home.packages = with pkgs;
  let
    rust = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-analyzer" "rustfmt" "rust-src" "rust-std" "rust-src" ];
      targets = [ "x86_64-pc-windows-gnu" ];
    };
  in
  [
    nixd
    rust
    python3
    sqlx-cli
    gcc
  ];
}
