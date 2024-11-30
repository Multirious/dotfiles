{ pkgs }:
let
  mapZshHelixKeys = keyMappings: /*zsh*/''
    export ZHM_MODE=insert
    ZHM_EXTENDING=0
    ZHM_SELECTION_LEFT=0
    ZHM_SELECTION_RIGHT=0
    ZHM_HISTORY=("" 0 0 0 0 0 0)
    ZHM_HISTORY_IDX=1
    ZHM_BEFORE_INSERT_CURSOR=0
    ZHM_BEFORE_INSERT_SELECTION_LEFT=0
    ZHM_BEFORE_INSERT_SELECTION_RIGHT=0

    ZHM_CURSOR_NORMAL='\e[2 q\e]12;#B4BEFE\a'
    ZHM_CURSOR_SELECT='\e[2 q\e]12;#F2CDCD\a'
    ZHM_CURSOR_INSERT='\e[5 q\e]12;white\a'
    zle_highlight=(region:fg=white,bg=#45475A)

    function dbg {
      tmux send -t 2 -l -- "$*"
      tmux send -t 2 Enter
    }

    function __zhm_update_mark {
      REGION_ACTIVE=1
      if (( (ZHM_SELECTION_RIGHT - ZHM_SELECTION_LEFT) <= 1 )); then
        MARK=$ZHM_SELECTION_LEFT
      elif (( (CURSOR + 1) == ZHM_SELECTION_RIGHT )); then
        MARK=$ZHM_SELECTION_LEFT
      elif (( CURSOR == ZHM_SELECTION_LEFT )); then
        MARK=$ZHM_SELECTION_RIGHT
      fi
    }

    function __zhm_update_history {
      if [[ "$ZHM_HISTORY[$((ZHM_HISTORY_IDX * 7 - 6))]" != "$1" ]]; then
        if (( ''${#ZHM_HISTORY} > ($ZHM_HISTORY_IDX * 7) )); then
          local count=$(((''${#ZHM_HISTORY} - ZHM_HISTORY_IDX * 7) - 1))
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

    function zhm_move_right {
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

      __zhm_update_mark
    }

    function zhm_move_left {
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

      __zhm_update_mark
    }

    function zhm_move_up {
      zle up-line
    }

    function zhm_move_down {
      zle down-line
    }

    function zhm_history_prev {
      ZHM_EXTENDING=0
      ZHM_SELECTION_LEFT=0
      ZHM_SELECTION_RIGHT=0
      local prev_histno=$HISTNO
      HISTNO=$((HISTNO - 1))
      ZHM_SELECTION_LEFT=$CURSOR
      ZHM_SELECTION_RIGHT=$(($CURSOR + 1))
      ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT < ''${#BUFFER} ? ZHM_SELECTION_RIGHT : ''${#BUFFER}))
      __zhm_update_mark
    }

    function zhm_history_next {
      ZHM_EXTENDING=0
      ZHM_SELECTION_LEFT=0
      ZHM_SELECTION_RIGHT=0
      local prev_histno=$HISTNO
      HISTNO=$((HISTNO + 1))
      ZHM_SELECTION_LEFT=$CURSOR
      ZHM_SELECTION_RIGHT=$(($CURSOR + 1))
      ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT < ''${#BUFFER} ? ZHM_SELECTION_RIGHT : ''${#BUFFER}))
      __zhm_update_mark
    }

    function zhm_move_next_word_start {
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

      __zhm_update_mark
    }

    function zhm_move_prev_word_start {
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

      __zhm_update_mark
    }

    function zhm_move_next_word_end {
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

      __zhm_update_mark
    }

    function zhm_insert {
      ZHM_BEFORE_INSERT_CURSOR=$CURSOR
      ZHM_BEFORE_INSERT_SELECTION_LEFT=$ZHM_SELECTION_LEFT
      ZHM_BEFORE_INSERT_SELECTION_RIGHT=$ZHM_SELECTION_RIGHT
      bindkey -A hins main
      export ZHM_MODE=insert
      CURSOR=$ZHM_SELECTION_LEFT
      echo -ne "\e[0m$ZHM_CURSOR_INSERT"
      __zhm_update_mark
    }

    function zhm_append {
      ZHM_BEFORE_INSERT_CURSOR=$CURSOR
      ZHM_BEFORE_INSERT_SELECTION_LEFT=$ZHM_SELECTION_LEFT
      ZHM_BEFORE_INSERT_SELECTION_RIGHT=$ZHM_SELECTION_RIGHT
      bindkey -A hins main
      export ZHM_MODE=insert
      CURSOR=$ZHM_SELECTION_RIGHT
      echo -ne "\e[0m$ZHM_CURSOR_INSERT"
      CURSOR=$((CURSOR - 1))
      __zhm_update_mark
      CURSOR=$((CURSOR + 1))
    }

    function zhm_normal {
      if [[ $ZHM_MODE == insert ]]; then
        if [[ $CURSOR == $ZHM_SELECTION_RIGHT ]]; then
          if (( ZHM_SELECTION_LEFT < ZHM_SELECTION_RIGHT  )); then
            CURSOR=$((CURSOR - 1))
          else
            ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT + 1))
            local buffer_len=''${#BUFFER}
            ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT < buffer_len ? ZHM_SELECTION_RIGHT : buffer_len))
          fi
        fi

        __zhm_update_history "$BUFFER" $ZHM_BEFORE_INSERT_CURSOR $ZHM_BEFORE_INSERT_SELECTION_LEFT $ZHM_BEFORE_INSERT_SELECTION_RIGHT $CURSOR $ZHM_SELECTION_LEFT $ZHM_SELECTION_RIGHT
      fi
      bindkey -A hnor main
      export ZHM_MODE=normal
      ZHM_EXTENDING=0
      echo -ne "\e[0m$ZHM_CURSOR_NORMAL"
      __zhm_update_mark
    }

    function zhm_select {
      bindkey -A hnor main
      export ZHM_MODE=normal
      if ((ZHM_EXTENDING == 1)); then
        ZHM_EXTENDING=0
        echo -ne "\e[0m$ZHM_CURSOR_NORMAL"
      else
        ZHM_EXTENDING=1
        echo -ne "\e[0m$ZHM_CURSOR_SELECT"
      fi
      __zhm_update_mark
    }

    function zhm_self_insert {
      local prev_cursor=$CURSOR
      zle .self-insert

      if (( prev_cursor == ZHM_SELECTION_LEFT )); then
        ZHM_SELECTION_LEFT=$((ZHM_SELECTION_LEFT + 1))
      fi
      ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT + 1))

      __zhm_update_mark
    }

    function zhm_insert_newline {
      local prev_cursor=$CURSOR
      BUFFER="''${BUFFER}
"
      CURSOR=$((CURSOR + 2))
      if (( prev_cursor == ZHM_SELECTION_LEFT )); then
        ZHM_SELECTION_LEFT=$((ZHM_SELECTION_LEFT + 2))
      fi
      ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT + 2))
      __zhm_update_mark
    }

    function zhm_delete_char_backward {
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

      __zhm_update_mark
    }

    function zhm_delete {
      local prev_cursor=$CURSOR
      local prev_left=$ZHM_SELECTION_LEFT
      local prev_right=$ZHM_SELECTION_RIGHT

      BUFFER="''${BUFFER:0:$ZHM_SELECTION_LEFT}''${BUFFER:$ZHM_SELECTION_RIGHT}"
      ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_LEFT + 1))
      local buffer_len=''${#BUFFER}
      ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT < buffer_len ? ZHM_SELECTION_RIGHT : buffer_len))
      CURSOR=$ZHM_SELECTION_LEFT

      ZHM_EXTENDING=0

      __zhm_update_history "$BUFFER" $prev_cursor $prev_left $prev_right $CURSOR $ZHM_SELECTION_LEFT $ZHM_SELECTION_RIGHT
      __zhm_update_mark
    }

    function zhm_change {
      local prev_cursor=$CURSOR
      local prev_left=$ZHM_SELECTION_LEFT
      local prev_right=$ZHM_SELECTION_RIGHT

      ZHM_BEFORE_INSERT_CURSOR=$CURSOR
      ZHM_BEFORE_INSERT_SELECTION_LEFT=$ZHM_SELECTION_LEFT
      ZHM_BEFORE_INSERT_SELECTION_RIGHT=$ZHM_SELECTION_RIGHT

      BUFFER="''${BUFFER:0:$ZHM_SELECTION_LEFT}''${BUFFER:$ZHM_SELECTION_RIGHT}"
      ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_LEFT + 1))
      local buffer_len=''${#BUFFER}
      ZHM_SELECTION_RIGHT=$((ZHM_SELECTION_RIGHT < buffer_len ? ZHM_SELECTION_RIGHT : buffer_len))
      CURSOR=$ZHM_SELECTION_LEFT
      ZHM_EXTENDING=0

      bindkey -A hins main
      export ZHM_MODE=insert
      CURSOR=$ZHM_SELECTION_LEFT
      echo -ne "$ZHM_CURSOR_INSERT"

      __zhm_update_mark
    }

    function zhm_undo {
      if ((ZHM_HISTORY_IDX > 1)); then
        ZHM_HISTORY_IDX=$((ZHM_HISTORY_IDX - 1))
        BUFFER="$ZHM_HISTORY[$(($ZHM_HISTORY_IDX * 7 - 6))]"
        CURSOR="$ZHM_HISTORY[$(((ZHM_HISTORY_IDX + 1) * 7 - 5))]"
        ZHM_SELECTION_LEFT="$ZHM_HISTORY[$(((ZHM_HISTORY_IDX + 1) * 7 - 4))]"
        ZHM_SELECTION_RIGHT="$ZHM_HISTORY[$(((ZHM_HISTORY_IDX + 1) * 7 - 3))]"
        __zhm_update_mark
      fi
    }

    function zhm_redo {
      if (((ZHM_HISTORY_IDX * 7) < ''${#ZHM_HISTORY})); then
        ZHM_HISTORY_IDX=$((ZHM_HISTORY_IDX + 1))
        BUFFER="$ZHM_HISTORY[$(($ZHM_HISTORY_IDX * 7 - 6))]"
        CURSOR="$ZHM_HISTORY[$((ZHM_HISTORY_IDX * 7 - 2))]"
        ZHM_SELECTION_LEFT="$ZHM_HISTORY[$((ZHM_HISTORY_IDX * 7 - 1))]"
        ZHM_SELECTION_RIGHT="$ZHM_HISTORY[$((ZHM_HISTORY_IDX * 7))]"
        __zhm_update_mark
      fi
    }

    function zhm_accept {
      ZHM_EXTENDING=0
      ZHM_SELECTION_LEFT=0
      ZHM_SELECTION_RIGHT=0
      zle accept-line
      MARK=
      REGION_ACTIVE=0
      ZHM_HISTORY=("" 0 0 0 0 0 0)
      ZHM_HISTORY_IDX=1
    }

    function precmd {
      ZHM_EXTENDING=0
      ZHM_SELECTION_LEFT=0
      ZHM_SELECTION_RIGHT=0
      MARK=0
      REGION_ACTIVE=1
      ZHM_HISTORY=("" 0 0 0 0 0 0)
      ZHM_HISTORY_IDX=1
      case $ZHM_MODE in
        insert)
          echo -ne "$ZHM_CURSOR_INSERT"
          ;;
        normal)
          echo -ne "$ZHM_CURSOR_NORMAL"
          ;;
      esac
    }

    function preexec {
      REGION_ACTIVE=0
    }

    zle -N zhm_move_left
    zle -N zhm_move_right
    zle -N zhm_move_up
    zle -N zhm_move_down
    zle -N zhm_history_next
    zle -N zhm_history_prev
    zle -N zhm_move_next_word_start
    zle -N zhm_move_prev_word_start
    zle -N zhm_move_next_word_end
    zle -N zhm_insert
    zle -N zhm_append
    zle -N zhm_normal
    zle -N zhm_select
    zle -N zhm_delete_char_backward
    zle -N zhm_delete
    zle -N zhm_self_insert
    zle -N zhm_insert_newline
    zle -N zhm_redo
    zle -N zhm_undo
    zle -N zhm_accept
    zle -N zhm_change

    bindkey -N hnor
    bindkey -N hins

    bindkey -A hins main
    
    bindkey -M hnor h zhm_move_left
    bindkey -M hnor l zhm_move_right
    bindkey -M hnor j zhm_move_down
    bindkey -M hnor k zhm_move_up
    bindkey -M hnor ^N zhm_history_next
    bindkey -M hnor ^P zhm_history_prev
    bindkey -M hnor i zhm_insert
    bindkey -M hnor a zhm_append
    bindkey -M hnor w zhm_move_next_word_start
    bindkey -M hnor b zhm_move_prev_word_start
    bindkey -M hnor e zhm_move_next_word_end
    bindkey -M hnor v zhm_select
    bindkey -M hnor d zhm_delete
    bindkey -M hnor c zhm_change
    bindkey -M hnor u zhm_undo
    bindkey -M hnor U zhm_redo
    bindkey -M hnor "^J" zhm_accept
    bindkey -M hnor "^M" zhm_accept

    bindkey -M hins -R " "-"~" zhm_self_insert
    bindkey -M hins "^?" zhm_delete_char_backward
    bindkey -M hins "^J" zhm_accept
    bindkey -M hins "^M" zhm_accept
    bindkey -M hins "^[" zhm_normal
    bindkey -M hins "^I" expand-or-complete
    bindkey -M hins "jk" zhm_normal
    bindkey -M hins "^P" zhm_history_prev
    bindkey -M hins "^N" zhm_history_next

    echo -ne "$ZHM_CURSOR_INSERT"
  '';

in
{ inherit mapZshHelixKeys; }
#<esc>gelvgl"@y;
#:w<ret>:sh ~/dotfiles/link <gt>/dev/null; tmux kill-pane -t 3; tmux split-window -t 2 -v; tmux send -t 2 jk%di; tmux send -t 3 "word Space another-word Space some@123host Space \\&\\& Space more Space sauce" Escape b <ret>
