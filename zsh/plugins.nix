{ fetchFromGitHub }:
let
  zsh-helix-mode = fetchFromGitHub {
    owner = "multirious";
    repo = "zsh-helix-mode";
    rev = "b6032e39be1868d0234cd72738542a61d963f03e";
    sha256 = "sha256-niZ1OY9zHc8W5QnD9vaF++PjYkm2Z9uDAG46WN+d5B4=";
  };
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
  )
  ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
    zhm_move_next_word_start
    zhm_move_next_word_end
  )

  source ${zsh-syntax-highlighting}/zsh-syntax-highlighting.zsh

  zhm-add-update-region-highlight-hook
''
