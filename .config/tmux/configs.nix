{ pkgs, ... }:
let
  plugins = with pkgs.tmuxPlugins; [
    {
      plugin = catppuccin.overrideAttrs (attr: {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "tmux";
          rev = "v2.1.0";
          hash = "sha256-kWixGC3CJiFj+YXqHRMbeShC/Tl+1phhupYAIo9bivE=";
        };
      });
      pre = /*bash*/''
        set -g @catppuccin_flavor 'mocha'

        set -g @catppuccin_status_background 'default'
        set -g @catppuccin_window_status_style "rounded"

        set -g @catppuccin_window_current_text " #W"
        set -g @catppuccin_window_default_text " #W"
      '';
      post  = plugin: /*bash*/''
        # set -g @catppuccin_window_flags_icon_format "##{?window_activity_flag,#{E:@catppuccin_window_flags_icon_activity},}##{?window_bell_flag,#{E:@catppuccin_window_flags_icon_bell},}##{?window_silence_flag,#{E:@catppuccin_window_flags_icon_silent},}##{?window_active,#{E:@catppuccin_window_flags_icon_current},}##{?window_last_flag,#{E:@catppuccin_window_flags_icon_last},}##{?window_marked_flag,#{E:@catppuccin_window_flags_icon_mark},}##{?window_zoomed_flag,#{E:@catppuccin_window_flags_icon_zoom},}"
        # set -g @catppuccin_window_current_left_separator "#[fg=#{@thm_surface_1},bg=terminal]"
        # set -g @catppuccin_window_current_right_separator "#[fg=#{@thm_surface_1},bg=terminal]"
        # set -g @catppuccin_window_left_separator "#[fg=#{@thm_surface_0},bg=terminal]"
        # set -g @catppuccin_window_right_separator "#[fg=#{@thm_surface_0},bg=terminal]"
      '';
    }
    yank
    # vim-tmux-navigator
    # cpu
    # battery
  ];
  config = /*bash*/''
  '';
in
{
  config = config;
  plugins = plugins;
  keymap = keymap;
}
