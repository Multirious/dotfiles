{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.crypto;
in
{
  options.myModules.crypto.enable = lib.mkEnableOption "Enable Crypto related applications";
  config = lib.mkIf cfg.enable {
    home.packages =
      let
        unstoppableSwap = pkgs.rustPlatform.buildRustPackage rec {
          pname = "unstoppable-swap";
          version = "1.0.0-rc.19";
          src = pkgs.fetchFromGitHub {
            owner = "UnstoppableSwap";
            repo = "core";
            rev = version;
            hash = "sha256-/Yi2HA3mC1R9ShFNwfcHWYb501YIifZC1RfF8K4Nm30=";
          };
          cargoHash = "sha256-cnBgS26VYGiP+nLMebgH/d1dCq7DdkZ50AR3Y3h9YbY=";
          buildInputs = with pkgs; [
            curl wget pkg-config dbus openssl_3 glib gtk3 webkitgtk librsvg
            libsoup_3
          ];
          nativeBuildInputs = with pkgs; [ pkg-config ];
          shellHook =
          let
            libraries = with pkgs; [
              webkitgtk gtk3 cairo gdk-pixbuf glib dbus openssl_3 librsvg
            ];
          in
          ''
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
          '';
        };
    in [
      unstoppableSwap
      pkgs.monero-gui
    ];
  };
}
