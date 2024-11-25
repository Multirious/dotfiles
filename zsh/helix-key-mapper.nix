{ pkgs }:
let
  mapZshHelixKeys = keyMappings:
  /*bash*/''
    bindkey
  '';
in
{ inherit mapZshHelixKeys; }
#:w<ret>:sh<space>~/dotfiles/link<space><gt>/dev/null<space>&&<space>tmux<space>send<minus>keys<space><minus>t<space>2<space>exec<space>Space<space>zsh<space>Enter<ret>
