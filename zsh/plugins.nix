{ fetchFromGitHub }:
let
  # zsh-helix-mode = fetchFromGitHub {
  #   owner = "multirious";
  #   repo = "zsh-helix-mode";
  #   rev = "3df28e4e75ff678f20f4776a6e07c6940e567a8e";
  #   sha256 = "sha256-4toXpJhc2Q2ItPzxo8Qrr4UIusk1lSrwxRQVJwVJHJY=";
  # };
  zsh-helix-mode = /home/peach/code-projects/zsh-helix-mode;
  zsh-autosuggestions = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-autosuggestions";
    rev = "0e810e5afa27acbd074398eefbe28d13005dbc15";
    sha256 = "sha256-85aw9OM2pQPsWklXjuNOzp9El1MsNb+cIiZQVHUzBnk=";
  };
  zsh-syntax-highlighting = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = "5eb677bb0fa9a3e60f0eff031dc13926e093df92";
    sha256 = "sha256-KRsQEDRsJdF7LGOMTZuqfbW6xdV5S38wlgdcCM98Y/Q=";
  };
in
''
  source <(fzf --zsh)
  
  source ${zsh-helix-mode}/zsh-helix-mode.plugin.zsh
  bindkey -M hxins "jk" zhm_normal

  source ${zsh-autosuggestions}/zsh-autosuggestions.plugin.zsh
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
    zhm_history_prev
    zhm_history_next
    zhm_prompt_accept
    zhm_accept
    zhm_accept_or_insert_newline
  )
  ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(
    zhm_move_right
    zhm_clear_selection_move_right
  )
  ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
    zhm_move_next_word_start
    zhm_move_next_word_end
  )

  source ${zsh-syntax-highlighting}/zsh-syntax-highlighting.zsh

  zhm-add-update-region-highlight-hook
''
