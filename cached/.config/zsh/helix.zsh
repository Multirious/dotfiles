ZHM_MODE=normal
ZHM_EXTENDING=0
ZHM_SELECTION_LEFT=0
ZHM_SELECTION_RIGHT=0
ZHM_HISTORY=("" 0 0 0 0 0 0)
ZHM_HISTORY_IDX=1
ZHM_BEFORE_INSERT_CURSOR=0
ZHM_BEFORE_INSERT_SELECTION_LEFT=0
ZHM_BEFORE_INSERT_SELECTION_RIGHT=0
ZHM_IN_CMD_HISTORY=0

function dbg {
  tmux send -t 2 -l -- "$*"
  tmux send -t 2 Enter
}

function __helix_update_mark {
  REGION_ACTIVE=1
  if (( (ZHM_SELECTION_RIGHT - ZHM_SELECTION_LEFT) <= 1 )); then
    MARK=$ZHM_SELECTION_LEFT
  elif (( (CURSOR + 1) == ZHM_SELECTION_RIGHT )); then
    MARK=$ZHM_SELECTION_LEFT
  elif (( CURSOR == ZHM_SELECTION_LEFT )); then
    MARK=$ZHM_SELECTION_RIGHT
  fi
}

function __helix_update_history {
  if [[ "$ZHM_HISTORY[$((ZHM_HISTORY_IDX * 7 - 6))]" != "$1" ]]; then
    if (( ${#ZHM_HISTORY} > ($ZHM_HISTORY_IDX * 7) )); then
      local count=$(((${#ZHM_HISTORY} - ZHM_HISTORY_IDX * 7) - 1))
      for i in {0..$count}; do
        shift -p ZHM_HISTORY
      done
    fi

    ZHM_HISTORY+=("$1")
    ZHM_HISTORY+=($2)
    ZHM_HISTORY+=($3)
    ZHM_HISTORY+=($4)
    ZHM_HISTORY+=($5)
    ZHM_HISTORY+=($6)
    ZHM_HISTORY+=($7)
    ZHM_HISTORY_IDX=$((ZHM_HISTORY_IDX + 1))

    ZHM_IN_CMD_HISTORY=0
  fi
}

function helix-move_right {
  local prev_cursor=$CURSOR
  CURSOR=$((CURSOR + 1))
  if (( (prev_cursor + 1) == ZHM_SELECTION_RIGHT )); then
    if (( ZHM_EXTENDING != 1 )); then
      ZHM_SELECTION_LEFT=$ZHM_SELECTION_RIGHT
    fi
    ZHM_SELECTION_RIGHT=$((CURSOR + 1))
  elif (( prev_cursor == ZHM_SELECTION_LEFT )); then
    ZHM_SELECTION_LEFT=$CURSOR
    if (( ZHM_EXTENDING != 1 )); then
      ZHM_SELECTION_RIGHT=$((CURSOR + 1))
    fi
  fi

  __helix_update_mark
}

function helix-move_left {
  local prev_cursor=$CURSOR
  CURSOR=$((CURSOR - 1))
  if (( prev_cursor == ZHM_SELECTION_LEFT )); then
    if (( ZHM_EXTENDING != 1 )); then
      ZHM_SELECTION_RIGHT=$ZHM_SELECTION_LEFT
    fi
    ZHM_SELECTION_LEFT=$CURSOR
  elif (( (prev_cursor + 1) == ZHM_SELECTION_RIGHT )); then
    ZHM_SELECTION_RIGHT=$((CURSOR + 1))
    if (( ZHM_EXTENDING != 1 )); then
      ZHM_SELECTION_LEFT=$CURSOR
    fi
  fi

  __helix_update_mark
}

function helix-move_up {
  helix-normal
  ZHM_EXTENDING=0
  ZHM_SELECTION_LEFT=0
  ZHM_SELECTION_RIGHT=0
  local prev_histno=$HISTNO
  HISTNO=$((HISTNO - 1))
  dbg "$prev_histno -> $HISTNO max: $HISTCMD "
  ZHM_SELECTION_LEFT=$CURSOR
  ZHM_SELECTION_RIGHT=$(($CURSOR + 1))
  ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT < ${#BUFFER} ? ZHM_SELECTION_RIGHT : ${#BUFFER}))
  __helix_update_mark
}

function helix-move_down {
  helix-normal
  ZHM_EXTENDING=0
  ZHM_SELECTION_LEFT=0
  ZHM_SELECTION_RIGHT=0
  local prev_histno=$HISTNO
  HISTNO=$((HISTNO + 1))
  dbg "$prev_histno -> $HISTNO max: $HISTCMD "
  ZHM_SELECTION_LEFT=$CURSOR
  ZHM_SELECTION_RIGHT=$(($CURSOR + 1))
  ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT < ${#BUFFER} ? ZHM_SELECTION_RIGHT : ${#BUFFER}))
  __helix_update_mark
}

function helix-move_next_word_start {
  # word another-word some@123host && more sauce
  local prev_cursor=$CURSOR
  local substring="${BUFFER:$CURSOR}"
  if [[ $substring =~ '([a-zA-Z0-9_]+ *|[^a-zA-Z0-9_ ]+ *)' ]]; then
    local mlen=${#match[$MBEGIN]}
    local skip=0
    if (( mlen > 1 )); then
      CURSOR=$((CURSOR + mlen - 1))
    else
      local substring="${BUFFER:$((CURSOR + 1))}"
      if [[ $substring =~ '([a-zA-Z0-9_]+ *|[^a-zA-Z0-9_]+) *' ]]; then
        local mlen=${#match[$MBEGIN]}
        CURSOR=$((CURSOR + mlen))
        skip=1
      fi
    fi

    if (( prev_cursor == ZHM_SELECTION_LEFT )); then
      if (( ZHM_EXTENDING != 1 )); then
        ZHM_SELECTION_LEFT=$((prev_cursor + skip))
        ZHM_SELECTION_RIGHT=$((CURSOR + 1))
      else
        if (( CURSOR >= ZHM_SELECTION_RIGHT )); then
          ZHM_SELECTION_LEFT=$((ZHM_SELECTION_RIGHT - 1))
          ZHM_SELECTION_RIGHT=$((CURSOR + 1))
        else
          ZHM_SELECTION_LEFT=$CURSOR
        fi
      fi
    elif (( (prev_cursor + 1) == ZHM_SELECTION_RIGHT )); then
      if (( ZHM_EXTENDING != 1 )); then
        ZHM_SELECTION_RIGHT=$((CURSOR + 1))
        ZHM_SELECTION_LEFT=$((prev_cursor + skip))
      else
        ZHM_SELECTION_RIGHT=$((CURSOR + 1))
      fi
    fi
  fi

  __helix_update_mark
}

function helix-move_prev_word_start {
  local rev_buffer="$(echo "$BUFFER" | rev)"
  local prev_cursor=$CURSOR
  local substring="${rev_buffer:$((-CURSOR - 1))}"
  if [[ $substring =~ '( *[a-zA-Z0-9_]+| *[^a-zA-Z0-9_ ]+| *)' ]]; then
    local mlen=${#match[$MBEGIN]}
    local skip=0
    if (( mlen > 1 )); then
      local buffer_len=${#BUFFER}
      CURSOR=$((CURSOR - mlen + (CURSOR < buffer_len ? 1 : 0)))
    else
      local substring="${rev_buffer:$((-CURSOR))}"
      if [[ $substring =~ '( *[a-zA-Z0-9_]+| *[^a-zA-Z0-9_ ]+| *)' ]]; then
        local mlen=${#match[$MBEGIN]}
        CURSOR=$((CURSOR - mlen))
        skip=1
      fi
    fi

    if (( (prev_cursor + 1) == ZHM_SELECTION_RIGHT )); then
      if (( ZHM_EXTENDING != 1 )); then
        ZHM_SELECTION_RIGHT=$((prev_cursor - skip + 1))
        ZHM_SELECTION_LEFT=$CURSOR
      else
        if (( CURSOR < ZHM_SELECTION_LEFT )); then
          ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_LEFT + 1))
          ZHM_SELECTION_LEFT=$CURSOR
        else
          ZHM_SELECTION_RIGHT=$((CURSOR + 1))
        fi
      fi
    elif (( prev_cursor == ZHM_SELECTION_LEFT )); then
      ZHM_SELECTION_LEFT=$CURSOR
      if (( ZHM_EXTENDING != 1 )); then
        ZHM_SELECTION_RIGHT=$((prev_cursor))
      fi
    fi
  fi

  __helix_update_mark
}

function helix-move_next_word_end {
  local prev_cursor=$CURSOR
  local substring="${BUFFER:$CURSOR}"
  if [[ $substring =~ '( *[a-zA-Z0-9_]+| *[^a-zA-Z0-9_ ]+| *)' ]]; then
    local mlen=${#match[$MBEGIN]}
    local skip=0
    if (( mlen > 1 )); then
      CURSOR=$((CURSOR + mlen - 1))
    else
      local substring="${BUFFER:$((CURSOR + 1))}"
      if [[ $substring =~ '( *[a-zA-Z0-9_]+| *[^a-zA-Z0-9_ ]+| *)' ]]; then
        local mlen=${#match[$MBEGIN]}
        CURSOR=$((CURSOR + mlen))
        skip=1
      fi
    fi

    if (( prev_cursor == ZHM_SELECTION_LEFT )); then
      if (( ZHM_EXTENDING != 1 )); then
        ZHM_SELECTION_LEFT=$((prev_cursor + skip))
        ZHM_SELECTION_RIGHT=$((CURSOR + 1))
      else
        if (( CURSOR >= ZHM_SELECTION_RIGHT )); then
          ZHM_SELECTION_LEFT=$((ZHM_SELECTION_RIGHT - 1))
          ZHM_SELECTION_RIGHT=$((CURSOR + 1))
        else
          ZHM_SELECTION_LEFT=$CURSOR
        fi
      fi
    elif (( (prev_cursor + 1) == ZHM_SELECTION_RIGHT )); then
      if (( ZHM_EXTENDING != 1 )); then
        ZHM_SELECTION_RIGHT=$((CURSOR + 1))
        ZHM_SELECTION_LEFT=$((prev_cursor + skip))
      else
        ZHM_SELECTION_RIGHT=$((CURSOR + 1))
      fi
    fi
  fi

  __helix_update_mark
}

function helix-insert {
  ZHM_BEFORE_INSERT_CURSOR=$CURSOR
  ZHM_BEFORE_INSERT_SELECTION_LEFT=$ZHM_SELECTION_LEFT
  ZHM_BEFORE_INSERT_SELECTION_RIGHT=$ZHM_SELECTION_RIGHT
  bindkey -A hins main
  ZHM_MODE=insert
  CURSOR=$ZHM_SELECTION_LEFT
  echo -ne '\e[5 q'
  __helix_update_mark
}

function helix-append {
  ZHM_BEFORE_INSERT_CURSOR=$CURSOR
  ZHM_BEFORE_INSERT_SELECTION_LEFT=$ZHM_SELECTION_LEFT
  ZHM_BEFORE_INSERT_SELECTION_RIGHT=$ZHM_SELECTION_RIGHT
  bindkey -A hins main
  ZHM_MODE=insert
  CURSOR=$ZHM_SELECTION_RIGHT
  echo -ne '\e[5 q'
  CURSOR=$((CURSOR - 1))
  __helix_update_mark
  CURSOR=$((CURSOR + 1))
}

function helix-normal {
  if [[ $ZHM_MODE == insert ]]; then
    if [[ $CURSOR == $ZHM_SELECTION_RIGHT ]]; then
      if (( ZHM_SELECTION_LEFT < ZHM_SELECTION_RIGHT  )); then
        CURSOR=$((CURSOR - 1))
      else
        ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT + 1))
        local buffer_len=${#BUFFER}
        ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT < buffer_len ? ZHM_SELECTION_RIGHT : buffer_len))
      fi
    fi

    __helix_update_history "$BUFFER" $ZHM_BEFORE_INSERT_CURSOR $ZHM_BEFORE_INSERT_SELECTION_LEFT $ZHM_BEFORE_INSERT_SELECTION_RIGHT $CURSOR $ZHM_SELECTION_LEFT $ZHM_SELECTION_RIGHT
  fi
  bindkey -A hnor main
  ZHM_MODE=normal
  ZHM_EXTENDING=0
  echo -ne '\e[2 q'
  __helix_update_mark
}

function helix-select {
  bindkey -A hnor main
  ZHM_MODE=normal
  if ((ZHM_EXTENDING == 1)); then
    ZHM_EXTENDING=0
  else
    ZHM_EXTENDING=1
  fi
  echo -ne '\e[2 q'
  __helix_update_mark
}

function helix-self_insert {
  local prev_cursor=$CURSOR
  zle .self-insert

  if (( prev_cursor == ZHM_SELECTION_LEFT )); then
    ZHM_SELECTION_LEFT=$((ZHM_SELECTION_LEFT + 1))
  fi
  ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT + 1))

  __helix_update_mark
}

function helix-delete_char_backward {
  zle backward-delete-char

  if (( prev_cursor == ZHM_SELECTION_LEFT )); then
    ZHM_SELECTION_LEFT=$(($ZHM_SELECTION_LEFT - 1))
    ZHM_SELECTION_RIGHT=$(($ZHM_SELECTION_RIGHT - 1))
    ZHM_SELECTION_LEFT=$((ZHM_SELECTION_LEFT > 0 ? ZHM_SELECTION_LEFT : 0))
    ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT > 0 ? ZHM_SELECTION_RIGHT : 0))
  else
    ZHM_SELECTION_RIGHT=$(($ZHM_SELECTION_RIGHT - 1))
    if (( ZHM_SELECTION_RIGHT < ZHM_SELECTION_LEFT )); then
      ZHM_SELECTION_LEFT=$ZHM_SELECTION_RIGHT
    fi
  fi

  __helix_update_mark
}

function helix-delete {
  local prev_cursor=$CURSOR
  local prev_left=$ZHM_SELECTION_LEFT
  local prev_right=$ZHM_SELECTION_RIGHT

  BUFFER="${BUFFER:0:$ZHM_SELECTION_LEFT}${BUFFER:$ZHM_SELECTION_RIGHT}"
  ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_LEFT + 1))
  local buffer_len=${#BUFFER}
  ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT < buffer_len ? ZHM_SELECTION_RIGHT : buffer_len))
  CURSOR=$ZHM_SELECTION_LEFT

  ZHM_EXTENDING=0

  __helix_update_history "$BUFFER" $prev_cursor $prev_left $prev_right $CURSOR $ZHM_SELECTION_LEFT $ZHM_SELECTION_RIGHT
  __helix_update_mark
}

function helix-undo {
  if ((ZHM_HISTORY_IDX > 1)); then
    ZHM_HISTORY_IDX=$((ZHM_HISTORY_IDX - 1))
    BUFFER="$ZHM_HISTORY[$(($ZHM_HISTORY_IDX * 7 - 6))]"
    CURSOR="$ZHM_HISTORY[$(((ZHM_HISTORY_IDX + 1) * 7 - 5))]"
    ZHM_SELECTION_LEFT="$ZHM_HISTORY[$(((ZHM_HISTORY_IDX + 1) * 7 - 4))]"
    ZHM_SELECTION_RIGHT="$ZHM_HISTORY[$(((ZHM_HISTORY_IDX + 1) * 7 - 3))]"
    __helix_update_mark
  fi
}

function helix-redo {
  if (((ZHM_HISTORY_IDX * 7) < ${#ZHM_HISTORY})); then
    ZHM_HISTORY_IDX=$((ZHM_HISTORY_IDX + 1))
    BUFFER="$ZHM_HISTORY[$(($ZHM_HISTORY_IDX * 7 - 6))]"
    CURSOR="$ZHM_HISTORY[$((ZHM_HISTORY_IDX * 7 - 2))]"
    ZHM_SELECTION_LEFT="$ZHM_HISTORY[$((ZHM_HISTORY_IDX * 7 - 1))]"
    ZHM_SELECTION_RIGHT="$ZHM_HISTORY[$((ZHM_HISTORY_IDX * 7))]"
    __helix_update_mark
  fi
}

function helix-accept {
  helix-normal
  ZHM_EXTENDING=0
  ZHM_SELECTION_LEFT=0
  ZHM_SELECTION_RIGHT=0
  zle accept-line
  MARK=
  REGION_ACTIVE=0
  ZHM_HISTORY=("" 0 0 0 0 0 0)
  ZHM_HISTORY_IDX=1
}

zle -N helix-move_left
zle -N helix-move_right
zle -N helix-move_down
zle -N helix-move_up
zle -N helix-move_next_word_start
zle -N helix-move_prev_word_start
zle -N helix-move_next_word_end
zle -N helix-insert
zle -N helix-append
zle -N helix-normal
zle -N helix-select
zle -N helix-delete_char_backward
zle -N helix-delete
zle -N helix-self_insert
zle -N helix-redo
zle -N helix-undo
zle -N helix-accept

bindkey -N hnor
bindkey -N hins

bindkey -A hnor main

bindkey -M hnor h helix-move_left
bindkey -M hnor j helix-move_down
bindkey -M hnor k helix-move_up
bindkey -M hnor l helix-move_right
bindkey -M hnor i helix-insert
bindkey -M hnor a helix-append
bindkey -M hnor w helix-move_next_word_start
bindkey -M hnor b helix-move_prev_word_start
bindkey -M hnor e helix-move_next_word_end
bindkey -M hnor v helix-select
bindkey -M hnor d helix-delete
bindkey -M hnor u helix-undo
bindkey -M hnor U helix-redo

bindkey -M hins -R " "-"~" helix-self_insert
bindkey -M hins "^?" helix-delete_char_backward
bindkey -M hins "^J" helix-accept
bindkey -M hins "^M" helix-accept
bindkey -M hins "^[" helix-normal
bindkey -M hins "^I" expand-or-complete
bindkey -M hins "jk" helix-normal

echo -ne '\e[2 q'

