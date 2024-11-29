{ pkgs }:
let
  mapZshHelixKeys = keyMappings: /*zsh*/''
    ZH_MODE=normal
    ZH_EXTENDING=0
    ZH_SELECTION_LEFT=0
    ZH_SELECTION_RIGHT=0
    ZH_HISTORY=("" 0 0)
    ZH_HISTORY_IDX=0

    function dbg {
      tmux send -t 2 -l -- "$*"
      tmux send -t 2 Enter
    }

    function __helix_update_mark {
      REGION_ACTIVE=1
      if (( (ZH_SELECTION_RIGHT - ZH_SELECTION_LEFT) <= 1 )); then
        MARK=$ZH_SELECTION_LEFT
      elif (( (CURSOR + 1) == ZH_SELECTION_RIGHT )); then
        MARK=$ZH_SELECTION_LEFT
      elif (( CURSOR == ZH_SELECTION_LEFT )); then
        MARK=$ZH_SELECTION_RIGHT
      fi
    }

    function __helix_update_history {
      if [[ "$ZH_HISTORY[$((ZH_HISTORY_IDX * 3))]" != "$BUFFER" ]]; then
        if (( ''${#ZH_HISTORY} < ($ZH_HISTORY_IDX + 1) )); then
          local count=$((''${#ZH_HISTORY} - $ZH_HISTORY_IDX - 1))
          for i in {0..$count}; do
            shift -p ZH_HISTORY
            shift -p ZH_HISTORY
            shift -p ZH_HISTORY
          done
        fi

        ZH_HISTORY+=("$BUFFER")
        ZH_HISTORY+=($ZH_SELECTION_LEFT)
        ZH_HISTORY+=($ZH_SELECTION_RIGHT)
      fi
    }

    function helix-move_right {
      local prev_cursor=$CURSOR
      CURSOR=$((CURSOR + 1))
      if (( (prev_cursor + 1) == ZH_SELECTION_RIGHT )); then
        if (( ZH_EXTENDING != 1 )); then
          ZH_SELECTION_LEFT=$ZH_SELECTION_RIGHT
        fi
        ZH_SELECTION_RIGHT=$((CURSOR + 1))
      elif (( prev_cursor == ZH_SELECTION_LEFT )); then
        ZH_SELECTION_LEFT=$CURSOR
        if (( ZH_EXTENDING != 1 )); then
          ZH_SELECTION_RIGHT=$((CURSOR + 1))
        fi
      fi

      __helix_update_mark
    }

    function helix-move_left {
      local prev_cursor=$CURSOR
      CURSOR=$((CURSOR - 1))
      if (( prev_cursor == ZH_SELECTION_LEFT )); then
        if (( ZH_EXTENDING != 1 )); then
          ZH_SELECTION_RIGHT=$ZH_SELECTION_LEFT
        fi
        ZH_SELECTION_LEFT=$CURSOR
      elif (( (prev_cursor + 1) == ZH_SELECTION_RIGHT )); then
        ZH_SELECTION_RIGHT=$((CURSOR + 1))
        if (( ZH_EXTENDING != 1 )); then
          ZH_SELECTION_LEFT=$CURSOR
        fi
      fi

      __helix_update_mark
    }

    function helix-move_next_word_start {
      # word another-word some@123host && more sauce
      local prev_cursor=$CURSOR
      local substring="''${BUFFER:$CURSOR}"
      if [[ $substring =~ '([a-zA-Z0-9_]+ *|[^a-zA-Z0-9_ ]+ *)' ]]; then
        local mlen=''${#match[$MBEGIN]}
        local skip=0
        if (( mlen > 1 )); then
          CURSOR=$((CURSOR + mlen - 1))
        else
          local substring="''${BUFFER:$((CURSOR + 1))}"
          if [[ $substring =~ '([a-zA-Z0-9_]+ *|[^a-zA-Z0-9_]+) *' ]]; then
            local mlen=''${#match[$MBEGIN]}
            CURSOR=$((CURSOR + mlen))
            skip=1
          fi
        fi

        if (( prev_cursor == ZH_SELECTION_LEFT )); then
          if (( ZH_EXTENDING != 1 )); then
            ZH_SELECTION_LEFT=$((prev_cursor + skip))
            ZH_SELECTION_RIGHT=$((CURSOR + 1))
          else
            if (( CURSOR >= ZH_SELECTION_RIGHT )); then
              ZH_SELECTION_LEFT=$((ZH_SELECTION_RIGHT - 1))
              ZH_SELECTION_RIGHT=$((CURSOR + 1))
            else
              ZH_SELECTION_LEFT=$CURSOR
            fi
          fi
        elif (( (prev_cursor + 1) == ZH_SELECTION_RIGHT )); then
          if (( ZH_EXTENDING != 1 )); then
            ZH_SELECTION_RIGHT=$((CURSOR + 1))
            ZH_SELECTION_LEFT=$((prev_cursor + skip))
          else
            ZH_SELECTION_RIGHT=$((CURSOR + 1))
          fi
        fi
      fi

      __helix_update_mark
    }

    function helix-move_prev_word_start {
      # 
      local rev_buffer="$(echo "$BUFFER" | rev)"
      local prev_cursor=$CURSOR
      local substring="''${rev_buffer:$((-CURSOR - 1))}"
      if [[ $substring =~ '( *[a-zA-Z0-9_]+| *[^a-zA-Z0-9_ ]+| *)' ]]; then
        local mlen=''${#match[$MBEGIN]}
        local skip=0
        if (( mlen > 1 )); then
          local buffer_len=''${#BUFFER}
          CURSOR=$((CURSOR - mlen + (CURSOR < buffer_len ? 1 : 0)))
        else
          local substring="''${rev_buffer:$((-CURSOR))}"
          if [[ $substring =~ '( *[a-zA-Z0-9_]+| *[^a-zA-Z0-9_ ]+| *)' ]]; then
            local mlen=''${#match[$MBEGIN]}
            CURSOR=$((CURSOR - mlen))
            skip=1
          fi
        fi

        if (( (prev_cursor + 1) == ZH_SELECTION_RIGHT )); then
          if (( ZH_EXTENDING != 1 )); then
            ZH_SELECTION_RIGHT=$((prev_cursor - skip + 1))
            ZH_SELECTION_LEFT=$CURSOR
          else
            if (( CURSOR < ZH_SELECTION_LEFT )); then
              ZH_SELECTION_RIGHT=$((ZH_SELECTION_LEFT + 1))
              ZH_SELECTION_LEFT=$CURSOR
            else
              ZH_SELECTION_RIGHT=$((CURSOR + 1))
            fi
          fi
        elif (( prev_cursor == ZH_SELECTION_LEFT )); then
          ZH_SELECTION_LEFT=$CURSOR
          if (( ZH_EXTENDING != 1 )); then
            ZH_SELECTION_RIGHT=$((prev_cursor))
          fi
        fi
      fi

      __helix_update_mark
    }

    function helix-move_next_word_end {
      local prev_cursor=$CURSOR
      local substring="''${BUFFER:$CURSOR}"
      if [[ $substring =~ '( *[a-zA-Z0-9_]+| *[^a-zA-Z0-9_ ]+| *)' ]]; then
        local mlen=''${#match[$MBEGIN]}
        local skip=0
        if (( mlen > 1 )); then
          CURSOR=$((CURSOR + mlen - 1))
        else
          local substring="''${BUFFER:$((CURSOR + 1))}"
          if [[ $substring =~ '( *[a-zA-Z0-9_]+| *[^a-zA-Z0-9_ ]+| *)' ]]; then
            local mlen=''${#match[$MBEGIN]}
            CURSOR=$((CURSOR + mlen))
            skip=1
          fi
        fi

        if (( prev_cursor == ZH_SELECTION_LEFT )); then
          if (( ZH_EXTENDING != 1 )); then
            ZH_SELECTION_LEFT=$((prev_cursor + skip))
            ZH_SELECTION_RIGHT=$((CURSOR + 1))
          else
            if (( CURSOR >= ZH_SELECTION_RIGHT )); then
              ZH_SELECTION_LEFT=$((ZH_SELECTION_RIGHT - 1))
              ZH_SELECTION_RIGHT=$((CURSOR + 1))
            else
              ZH_SELECTION_LEFT=$CURSOR
            fi
          fi
        elif (( (prev_cursor + 1) == ZH_SELECTION_RIGHT )); then
          if (( ZH_EXTENDING != 1 )); then
            ZH_SELECTION_RIGHT=$((CURSOR + 1))
            ZH_SELECTION_LEFT=$((prev_cursor + skip))
          else
            ZH_SELECTION_RIGHT=$((CURSOR + 1))
          fi
        fi
      fi

      __helix_update_mark
    }

    function helix-insert {
      bindkey -A hins main
      ZH_MODE=insert
      CURSOR=$ZH_SELECTION_LEFT
      echo -ne '\e[5 q'
      __helix_update_mark
    }

    function helix-append {
      bindkey -A hins main
      ZH_MODE=insert
      CURSOR=$ZH_SELECTION_RIGHT
      echo -ne '\e[5 q'
      CURSOR=$((CURSOR - 1))
      __helix_update_mark
      CURSOR=$((CURSOR + 1))
    }

    function helix-normal {
      if [[ $ZH_MODE == insert ]]; then
        if [[ $CURSOR == $ZH_SELECTION_RIGHT ]]; then
          if (( ZH_SELECTION_LEFT < ZH_SELECTION_RIGHT  )); then
            CURSOR=$((CURSOR - 1))
          else
            ZH_SELECTION_RIGHT=$((ZH_SELECTION_RIGHT + 1))
            local buffer_len=''${#BUFFER}
            ZH_SELECTION_RIGHT=$((ZH_SELECTION_RIGHT < buffer_len ? ZH_SELECTION_RIGHT : buffer_len))
          fi
        fi

        __helix_update_history
      fi
      bindkey -A hnor main
      ZH_MODE=normal
      ZH_EXTENDING=0
      echo -ne '\e[2 q'
      __helix_update_mark
    }

    function helix-select {
      bindkey -A hnor main
      ZH_MODE=normal
      if ((ZH_EXTENDING == 1)); then
        ZH_EXTENDING=0
      else
        ZH_EXTENDING=1
      fi
      echo -ne '\e[2 q'
      __helix_update_mark
    }

    function helix-self_insert {
      local prev_cursor=$CURSOR
      zle .self-insert

      if (( prev_cursor == ZH_SELECTION_LEFT )); then
        ZH_SELECTION_LEFT=$((ZH_SELECTION_LEFT + 1))
        ZH_SELECTION_RIGHT=$((ZH_SELECTION_RIGHT + 1))
      else
        ZH_SELECTION_RIGHT=$((ZH_SELECTION_RIGHT + 1))
      fi

      __helix_update_mark
    }

    function helix-delete_char_backward {
      local prev_cursor=$CURSOR
      zle backward-delete-char

      if (( prev_cursor == ZH_SELECTION_LEFT )); then
        ZH_SELECTION_LEFT=$(($ZH_SELECTION_LEFT - 1))
        ZH_SELECTION_RIGHT=$(($ZH_SELECTION_RIGHT - 1))
        ZH_SELECTION_LEFT=$((ZH_SELECTION_LEFT > 0 ? ZH_SELECTION_LEFT : 0))
        ZH_SELECTION_RIGHT=$((ZH_SELECTION_RIGHT > 0 ? ZH_SELECTION_RIGHT : 0))
      else
        ZH_SELECTION_RIGHT=$(($ZH_SELECTION_RIGHT - 1))
        if (( ZH_SELECTION_RIGHT < ZH_SELECTION_LEFT )); then
          ZH_SELECTION_LEFT=$ZH_SELECTION_RIGHT
        fi
      fi

      __helix_update_mark
    }

    function helix-delete {
      BUFFER="''${BUFFER:0:$ZH_SELECTION_LEFT}''${BUFFER:$ZH_SELECTION_RIGHT}"
      __helix_update_history
      ZH_SELECTION_RIGHT=$((ZH_SELECTION_LEFT + 1))
      local buffer_len=''${#BUFFER}
      ZH_SELECTION_RIGHT=$((ZH_SELECTION_RIGHT < buffer_len ? ZH_SELECTION_RIGHT : buffer_len))
      ZH_EXTENDING=0

      __helix_update_mark
    }

    function helix-undo {
      if ((ZSH_HISTORY_IDX > 0)); then
        ZSH_HISTORY_IDX=$((ZSH_HISTORY_IDX - 1))
        BUFFER="$ZSH_HISTORY[$ZSH_HISTORY_IDX]"
        ZH_SELECTION_LEFT="$ZSH_HISTORY[$((ZSH_HISTORY_IDX + 1))]"
        ZH_SELECTION_RIGHT="$ZSH_HISTORY[$((ZSH_HISTORY_IDX + 2))]"
        __helix_update_mark
      fi
    }

    function helix-redo {
      if ((ZSH_HISTORY_IDX < (''${#ZH_HISTORY} - 1))); then
        ZSH_HISTORY_IDX=$((ZSH_HISTORY_IDX - 1))
        BUFFER="$ZSH_HISTORY[$ZSH_HISTORY_IDX]"
        ZH_SELECTION_LEFT="$ZSH_HISTORY[$((ZSH_HISTORY_IDX + 1))]"
        ZH_SELECTION_RIGHT="$ZSH_HISTORY[$((ZSH_HISTORY_IDX + 2))]"
        __helix_update_mark
      fi
    }

    function helix-accept {
      helix-normal
      ZH_EXTENDING=0
      ZH_SELECTION_LEFT=0
      ZH_SELECTION_RIGHT=0
      zle accept-line
      MARK=
      REGION_ACTIVE=0
      ZH_HISTORY=("" 0 0)
      ZH_HISTORY_IDX=0
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
    zle -N helix-delete
    zle -N helix-self_insert
    zle -N helix-redo
    zle -N helix-undo
    zle -N helix-accept

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
  '';

in
{ inherit mapZshHelixKeys; }
#<esc>gelvgl"@y;
#:w<ret>:sh ~/dotfiles/link <gt>/dev/null; tmux kill-pane -t 3; tmux split-window -t 2 -v; tmux send -t 2 jk%di; tmux send -t 3 "iword Space another-word Space some@123host Space \\&\\& Space more Space sauce" <ret>
