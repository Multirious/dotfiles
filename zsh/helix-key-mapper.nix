{ pkgs }:
let
  mapZshHelixKeys = keyMappings: /*bash*/''
    ZH_MODE=normal
    ZH_EXTENDING=0
    ZH_SELECTION_START=0
    ZH_SELECTION_END=0
    ZH_PREV_SELECTION_START=0
    ZH_PREV_SELECTION_END=0
    ZH_PREV_CURSOR=0

    function __helix_before_movement {
      ZH_PREV_SELECTION_START=$ZH_SELECTION_START
      ZH_PREV_SELECTION_END=$ZH_SELECTION_END
      ZH_PREV_CURSOR=$CURSOR
    }

    function __helix_after_movement {
      if [[ $ZH_EXTENDING == 1 ]]; then
        if [[ $ZH_PREV_SELECTION_START == $ZH_PREV_SELECTION_END ]]; then
          if [[ $CURSOR > $ZH_PREV_CURSOR ]]; then
            ZH_SELECTION_END=$CURSOR
          elif [[ $CURSOR < $ZH_PREV_CURSOR ]]; then
            ZH_SELECTION_START=$CURSOR
          fi
        else
          if [[ $ZH_PREV_CURSOR == $ZH_PREV_SELECTION_START ]]; then
            ZH_SELECTION_START=$CURSOR
          else
            ZH_SELECTION_END=$CURSOR
          fi
        fi
      else
        if [[ $ZH_PREV_CURSOR == $ZH_PREV_SELECTION_START ]]; then
          ZH_SELECTION_START=$CURSOR
          ZH_SELECTION_END=$ZH_PREV_SELECTION_START
        else
          ZH_SELECTION_END=$CURSOR
          ZH_SELECTION_START=$ZH_PREV_SELECTION_END
        fi
      fi

      REGION_ACTIVATE=1

      if [[ $CURSOR == $ZH_SELECTION_START ]]; then
        MARK=$(($ZH_SELECTION_END + 1))
      else
        MARK=$(($ZH_SELECTION_START + 1))
      fi
    }

    function helix-move_next_word_start {
      __helix_before_movement
      zle vi-forward-word
      __helix_after_movement
    }

    function helix-move_prev_word_start {
      __helix_before_movement
      zle vi-backward-word
      __helix_after_movement
    }

    function helix-move_next_word_end {
      __helix_before_movement
      zle vi-forward-word-end
      __helix_after_movement
    }
    # function helix-down {
    #   zle -U vi-backward-char
    # }
    # function helix-down {
    #   zle -U vi-backward-char
    # }
    function helix-move_right {
      __helix_before_movement
      zle vi-forward-char
      __helix_after_movement
    }

    function helix-move_left {
      __helix_before_movement
      zle vi-backward-char
      __helix_after_movement
    }

    function helix-insert_before_selection {
      bindkey -A hins main
      ZH_HELIX_MODE=insert
      echo -ne '\e[5 q'
    }

    function helix-insert_after_selection {
      bindkey -A hins main
      ZH_HELIX_MODE=insert
      CURSOR=$(($CURSOR + 1))
      echo -ne '\e[5 q'
    }

    function helix-normal_mode {
      bindkey -A hnor main
      ZH_HELIX_MODE=normal
      echo -ne '\e[2 q'
    }

    function helix-delete_char_backward {
      zle backward-delete-char
    }

    function helix-select_mode {
      if [[ $ZH_EXTENDING == 1 ]]; then
        ZH_EXTENDING=0
      else
        ZH_EXTENDING=1
      fi
    }

    function helix-self_insert {
      if [[ $CURSOR == $ZH_SELECTION_START ]]; then
        zle .self-insert
        ZH_SELECTION_START=$(($ZH_SELECTION_START + 1))
        __helix_after_movement
      else
        zle .self-insert
        ZH_SELECTION_END=$(($ZH_SELECTION_END + 1))
        __helix_after_movement
      fi
    }

    zle -N helix-move_left
    zle -N helix-move_right
    zle -N helix-move_next_word_start
    zle -N helix-move_prev_word_start
    zle -N helix-move_next_word_end
    zle -N helix-insert_before_selection
    zle -N helix-insert_after_selection
    zle -N helix-normal_mode
    zle -N helix-select_mode
    zle -N helix-delete_char_backward
    zle -N helix-self_insert

    bindkey -N hnor
    bindkey -N hins

    bindkey -A hnor main
    
    bindkey -M hnor h helix-move_left
    # bindkey -M hnor j
    # bindkey -M hnor k
    bindkey -M hnor l helix-move_right
    bindkey -M hnor i helix-insert_before_selection
    bindkey -M hnor a helix-insert_after_selection
    bindkey -M hnor w helix-move_next_word_start
    bindkey -M hnor b helix-move_prev_word_start
    bindkey -M hnor e helix-move_next_word_end
    bindkey -M hnor v helix-select_mode

    bindkey -M hins -R " "-"~" helix-self_insert
    bindkey -M hins "^?" helix-delete_char_backward
    bindkey -M hins "^J" accept-line
    bindkey -M hins "^M" accept-line
    bindkey -M hins "^[" helix-normal_mode

    echo -ne '\e[2 q'
  '';
in
{ inherit mapZshHelixKeys; }
#:w<ret>:sh ~/dotfiles/link <gt>/dev/null; tmux kill-pane -t 3; tmux split-window -t 2 -v<ret>
