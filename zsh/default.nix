{ mkConfig, dontPatch, keyMappings, writeScript, fetchFromGitHub }:
let
  plugins = writeScript "dotconfig-zsh-plugins"
    (let
      zsh-helix-mode = fetchFromGitHub {
        owner = "multirious";
        repo = "zsh-helix-mode";
        rev = "165231b3f8677e15b922d21e7cdbe11991c88e0b";
        sha256 = "sha256-EbXBWwwXJdt6f97+A55M0wIb2mDUDZDEKs2RxAus14c=";
      };
      zsh-autosuggestions = fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-autosuggestions";
        rev = "0e810e5afa27acbd074398eefbe28d13005dbc15";
        sha256 = "sha256-85aw9OM2pQPsWklXjuNOzp9El1MsNb+cIiZQVHUzBnk=";
      };
    in
    ''
      source ${zsh-helix-mode}/zsh-helix-mode.plugin.zsh
      bindkey -M hins "jk" zhm_normal

      source ${zsh-autosuggestions}/zsh-autosuggestions.plugin.zsh
      ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
        zhm_history_prev
        zhm_history_next
      )
      ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(
        zhm_move_right
        zhm_goto_line_end
      )
      ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
        zhm_move_next_word_start
        zhm_move_prev_word_start
        zhm_move_next_word_end
      )
    '');
in
mkConfig {
  name = "dotconfig-zsh";
  files = {
    "env" = ./env;
    "login" = ./login;
    "logout" = ./logout;
    "interactive" = ./interactive;
    "completion.zsh" = ./completion.zsh;
    "dirs.zsh" = ./dirs.zsh;
    "plugins.zsh" = "${plugins}";
  };
}
