{ pkgs, ... }:
{
  home.packages = with pkgs;
  let
    tmux = pkgs.tmux.overrideAttrs (finalAttrs: prevAttrs:
      {
        version = "d3c39375d5e9f4a0dcb5bd210c912d70ceca5de9";
        src = fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = "d3c39375d5e9f4a0dcb5bd210c912d70ceca5de9";
          hash = "sha256-CTo6NJTuS2m5W6WyqTHg4G6NiRqt874pFGvVgmbKeC8=";
        };
      }
    );
  in
  [
    helix
    tmux
    zsh
    starship
  ];
}
