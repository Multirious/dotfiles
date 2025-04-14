{ config, pkgs, ... }:
{
  home.packages = with pkgs;
  let
    librewolf-wayland = pkgs.librewolf-wayland.overrideAttrs (a:
      {
        buildCommand = a.buildCommand + ''
          wrapProgram "$executablePath" \
            --set 'HOME' '${config.home.homeDirectory}/.local/share/librewolf'
        '';
      }
    );
  in
  [
    tor-browser
    librewolf-wayland 
  ];
}
