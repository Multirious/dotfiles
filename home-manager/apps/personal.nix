{ config, pkgs, ... }:
{
  home.packages = with pkgs;
  let
    steam = pkgs.steam.override {
      extraEnv.HOME = "${config.home.homeDirectory}/.local/share/steam";
    };
    discord = pkgs.discord.overrideAttrs (prev: {
      version = "0.0.93";
      src = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/linux/0.0.93/discord-0.0.93.tar.gz";
        hash = "sha256-/CTgRWMi7RnsIrzWrXHE5D9zFte7GgqimxnvJTj3hFY=";
      };
    });
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
      buildInputs = [
        curl wget pkg-config dbus openssl_3 glib gtk3 webkitgtk librsvg
        libsoup_3
      ];
      nativeBuildInputs = [ pkg-config ];
      shellHook =
      let
        libraries = [
          webkitgtk gtk3 cairo gdk-pixbuf glib dbus openssl_3 librsvg
        ];
      in
      ''
        export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
      '';
    };
  in
  [
    yt-dlp
    keepassxc
    steam
    reaper
    megasync
    discord
    libsForQt5.dolphin
    lan-mouse
    blender
    vlc
    zip
    unzip
    rar
    steam-run
    p7zip
    udiskie
    postgresql
    bottles
    obsidian
    geary
    fyi
    scooter
    xclicker
    libnotify
    prismlauncher
    qpwgraph
    gimp
    (flameshot.override { enableWlrSupport = true; })
    nomacs
    monero-gui
    google-chrome
    logmein-hamachi
    libreoffice
    btop
  ];
}
