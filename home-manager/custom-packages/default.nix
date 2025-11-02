{ pkgs ? import <nixpkgs> {} }:
{
  sitala = pkgs.callPackage ./sitala.nix {};
}
