source <(fzf --zsh)

source /nix/store/hr6sxi02x7gmi30kv8kvw43faqr5qym3-source/zsh-helix-mode.plugin.zsh
bindkey -M hxins "jk" zhm_normal

source /nix/store/lqxgy066krnq2z8pvhqxrj7pcldz1xkg-source/zsh-autosuggestions.plugin.zsh
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

source /nix/store/7kwnn9isvznvhbwqx2syvfcd6716bkwh-source/zsh-syntax-highlighting.zsh

zhm-add-update-region-highlight-hook
