let 
  mappings = {
    normal = {
      v = "select_mode";
      i = "insert_mode";
      h = "move_left";
      j = "move_down";
      k = "move_up";
      l = "move_right";
      w = "move_next_word_start";
      b = "move_prev_word_start";
      e = "move_next_word_end";
      W = "move_next_long_word_start";
      B = "move_prev_long_word_start";
      E = "move_next_long_word_end";
      Ctrl-u = "cursor_half_page_up";
      Ctrl-d = "cursor_half_page_down";
      y = "yank";
      x = "extend_line_below";
      X = "extend_to_line_bounds";
      Alt-x = "shrink_to_line_bounds";
      g = {
        g = "goto_start";
        e = "goto_end";
        h = "goto_line_start";
        l = "goto_line_end";
        s = "goto_line_first_nonwhitespace";
      };
      ";" = "collapse_selections";
      "Alt-;" = "flip_selections";
      "Alt-:" = "ensure_selections_forward";
      "]" = {
        p = "goto_next_paragraph";
      };
      "[" = {
        p = "goto_prev_paragraph";
      };
      m = {
        m = "match_brackets";
      };
      "/" = "search";
      "?" = "rsearch";
      n = "search_next";
      N = "search_prev";
      "*" = "search_selection";
      Ctrl-p = "prev";
      Ctrl-n = "next";
    };
    insert = {
      j.k = "normal_mode";
      Ctrl-p = "prev";
      Ctrl-n = "next";
    };
  };
  definitions = {
    normal_mode = "Enter normal mode";
    select_mode = "Enter select mode";
    insert_mode = "Enter insert mode";
    move_left = "Move left";
    move_down = "Move down";
    move_up = "Move up";
    move_right = "Move right";
    move_next_word_start = "Move next word start";
    move_prev_word_start = "Move previous word start";
    move_next_word_end = "Move next word end";
    move_next_long_word_start = "Move next WORD start";
    move_prev_long_word_start = "Move previous WORD start";
    move_next_long_word_end = "Move next WORD end";
    cursor_half_page_up = "Move cursor and page half page up";
    cursor_half_page_down = "Move cursor and page half page down";
    yank = "Yank selection";
    extend_line_below = "Select current line, if already selected, extend to next line";
    extend_to_line_bounds = "Extend selection to line bounds (line-wise selection)";
    shrink_to_line_bounds = "	Shrink selection to line bounds (line-wise selection)";
    goto_start = "Go to line number <n> else start";
    goto_end = "Go to the end";
    goto_line_start = "Go to the start of the line";
    goto_line_end = "	Go to the end of the line";
    goto_line_first_nonwhitespace = "Go to first non-whitespace character of the line";
    collapse_selections = "Collapse selection onto a single cursor";
    flip_selections = "Flip selection cursor and anchor";
    ensure_selections_forward = "Ensures the selection is in forward direction";
    goto_next_paragraph = "Go to next paragraph";
    goto_prev_paragraph = "Go to previous paragraph";
    match_brackets = "Goto matching bracket";
    search = "Search for pattern";
    rsearch = "Search for previous pattern";
    search_next = "Search next";
    search_prev = "Search previous";
    search_selection = "Use current selection as the search pattern";
    next = "Generic next";
    prev = "Generic previous";
  };
in
{
  inherit mappings;
  inherit definitions;
}
