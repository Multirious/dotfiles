ZH_MODE=normal
ZH_EXTENDING=0
ZH_SELECTION_START=0
ZH_SELECTION_END=0
ZH_PREV_SELECTION_START=0
ZH_PREV_SELECTION_END=0
ZH_PREV_CURSOR=0

function __helix_update_prev {
  ZH_PREV_SELECTION_START=$ZH_SELECTION_START
  ZH_PREV_SELECTION_END=$ZH_SELECTION_END
  ZH_PREV_CURSOR=$CURSOR
}

function dbg {
  tmux send -t 2 "$1" Enter
}

function __helix_selection_head {
  if ((ZH_PREV_SELECTION_START == ZH_PREV_SELECTION_END)); then
    echo both
  elif ((ZH_PREV_CURSOR == ZH_PREV_SELECTION_START)); then
    echo start
  elif ((ZH_PREV_CURSOR == ZH_PREV_SELECTION_END)); then
    echo end
  else
    echo none
  fi
}

function __helix_update_mark {
  REGION_ACTIVE=1
  if ((CURSOR == ZH_SELECTION_START)); then
    MARK=$(($ZH_SELECTION_END+1))
  else
    MARK=$(($ZH_SELECTION_START))
  fi
  
}

function helix-move_next_word_start {
  __helix_update_prev
  local selection_head=$(__helix_selection_head)

  local substring="${BUFFER:$(($CURSOR + 1))}"
  if [[ $substring =~ '([a-zA-Z0-9_]+ *|[^a-zA-Z0-9_]+)' ]]; then
    local mlen="${#match[$MBEGIN]}"
    CURSOR=$((CURSOR + mlen))
  else
    CURSOR="${#BUFFER}"
  fi

  ZH_SELECTION_END=$CURSOR
  ZH_SELECTION_START=$(($ZH_PREV_SELECTION_END + 1))

  __helix_update_mark
}

function helix-move_prev_word_start {
  __helix_update_prev
  local selection_head=$(__helix_selection_head)

  # word another-word some@123host && more sauce @a@
  local rev_buffer="$(echo "$BUFFER" | rev)"
  local substring="${rev_buffer:$((-$CURSOR))}"
  if [[ $substring =~ '( *[a-zA-Z0-9_]+| ?[^ a-zA-Z0-9_]+)' ]]; then
    local mlen="${#match[$MBEGIN]}"
    CURSOR=$((CURSOR - mlen))
  else
    CURSOR="${#BUFFER}"
  fi

  ZH_SELECTION_END=$(($ZH_PREV_SELECTION_START - 1))
  ZH_SELECTION_START=$CURSOR

  __helix_update_mark
}

function helix-move_next_word_end {
  __helix_update_prev
  local selection_head=$(__helix_selection_head)

  # word another-word some@123host && more sauce @a@
  local substring="${BUFFER:$(($CURSOR + 1))}"
  if [[ $substring =~ '( *[a-zA-Z0-9_]+| ?[^ a-zA-Z0-9_]+)' ]]; then
    local mlen="${#match[$MBEGIN]}"
    CURSOR=$((CURSOR + mlen))
  else
    CURSOR="${#BUFFER}"
  fi

  ZH_SELECTION_END=$CURSOR
  ZH_SELECTION_START=$(($ZH_PREV_SELECTION_END + 1))

  __helix_update_mark
}
# function helix-down {
#   zle -U vi-backward-char
# }
# function helix-down {
#   zle -U vi-backward-char
# }
function helix-move_right {
  __helix_update_prev
  local selection_head=$(__helix_selection_head)

  CURSOR=$(($CURSOR + 1))
  if [[ $selection_head == start ]]; then
    ZH_SELECTION_START=$CURSOR
    if ((ZH_EXTENDING == 0)); then
      ZH_SELECTION_END=$(($ZH_SELECTION_START))
    fi
  else
    ZH_SELECTION_END=$CURSOR
    if ((ZH_EXTENDING == 0)); then
      ZH_SELECTION_START=$(($ZH_PREV_SELECTION_END + 1))
    fi
  fi

  __helix_update_mark
}

function helix-move_left {
  __helix_update_prev
  local selection_head=$(__helix_selection_head)

  CURSOR=$(($CURSOR - 1))
  if [[ $selection_head == end ]]; then
    ZH_SELECTION_END=$CURSOR
    if ((ZH_EXTENDING == 0)); then
      ZH_SELECTION_START=$(($ZH_PREV_SELECTION_END - 1))
    fi
  else
    ZH_SELECTION_START=$CURSOR
    if ((ZH_EXTENDING == 0)); then
      ZH_SELECTION_END=$(($ZH_PREV_SELECTION_START - 1))
    fi
  fi

  __helix_update_mark
}

function helix-delete_char_backward {
  zle backward-delete-char
}

function helix-insert {
  bindkey -A hins main
  ZH_HELIX_MODE=insert
  CURSOR=$(($ZH_SELECTION_START))
  echo -ne '\e[5 q'
  __helix_update_mark
}

function helix-append {
  bindkey -A hins main
  ZH_HELIX_MODE=append
  CURSOR=$(($ZH_SELECTION_END + 1))
  echo -ne '\e[5 q'
  __helix_update_mark
}

function helix-normal {
  if [[ $ZH_HELIX_MODE == append ]]; then
    CURSOR=$((CURSOR - 1))
  fi
  bindkey -A hnor main
  ZH_HELIX_MODE=normal
  ZH_EXTENDING=0
  echo -ne '\e[2 q'
  __helix_update_mark
}

function helix-select {
  bindkey -A hnor main
  ZH_HELIX_MODE=normal
  if ((ZH_EXTENDING == 1)); then
    ZH_EXTENDING=0
  else
    ZH_EXTENDING=1
  fi
  echo -ne '\e[2 q'
}

function helix-self_insert {
  __helix_update_prev

  zle .self-insert

  case $ZH_HELIX_MODE in
    insert)
      ZH_SELECTION_START=$(($ZH_SELECTION_START + 1))
      ZH_SELECTION_END=$(($ZH_SELECTION_END + 1))
      ;;
    append)
      ZH_SELECTION_END=$(($ZH_SELECTION_END + 1))
      ;;
  esac

  __helix_update_mark
}

function helix-accept {
  ZH_EXTENDING=0
  ZH_SELECTION_START=0
  ZH_SELECTION_END=0
  ZH_PREV_SELECTION_START=0
  ZH_PREV_SELECTION_END=0
  ZH_PREV_CURSOR=0
}

zle -N helix-move_left
zle -N helix-move_right
zle -N helix-move_next_word_start
zle -N helix-move_prev_word_start
zle -N helix-move_next_word_end
zle -N helix-insert
zle -N helix-append
zle -N helix-normal
zle -N helix-select
zle -N helix-delete_char_backward
zle -N helix-self_insert

bindkey -N hnor
bindkey -N hins

bindkey -A hnor main

bindkey -M hnor h helix-move_left
# bindkey -M hnor j
# bindkey -M hnor k
bindkey -M hnor l helix-move_right
bindkey -M hnor i helix-insert
bindkey -M hnor a helix-append
bindkey -M hnor w helix-move_next_word_start
bindkey -M hnor b helix-move_prev_word_start
bindkey -M hnor e helix-move_next_word_end
bindkey -M hnor v helix-select

bindkey -M hins -R " "-"~" helix-self_insert
bindkey -M hins "^?" helix-delete_char_backward
bindkey -M hins "^J" accept-line
bindkey -M hins "^M" accept-line
bindkey -M hins "^[" helix-normal
bindkey -M hins "^I" expand-or-complete
bindkey -M hins "jk" helix-normal

echo -ne '\e[2 q'

