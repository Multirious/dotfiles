source /nix/store/ag093hb1m60cvl673gi0k7195fkw7nzf-source/zsh-helix-mode.plugin.zsh
bindkey -M hxins "jk" zhm_normal

source /nix/store/lqxgy066krnq2z8pvhqxrj7pcldz1xkg-source/zsh-autosuggestions.plugin.zsh
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
