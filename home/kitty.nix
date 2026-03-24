{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      # Font
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;

      # Monochrome + semantic color
      foreground = "#d4d4d4";
      background = "#0a0a0a";
      selection_foreground = "#0a0a0a";
      selection_background = "#d4d4d4";
      cursor = "#d4d4d4";

      # Black
      color0 = "#0a0a0a";
      color8 = "#5a5a5a";
      # Red (errors)
      color1 = "#e55561";
      color9 = "#e55561";
      # Green (success)
      color2 = "#7ec480";
      color10 = "#7ec480";
      # Yellow (warnings)
      color3 = "#e5a230";
      color11 = "#e5a230";
      # Blue (muted — rarely visible)
      color4 = "#8a8a8a";
      color12 = "#8a8a8a";
      # Magenta (muted)
      color5 = "#9a9a9a";
      color13 = "#9a9a9a";
      # Cyan (muted)
      color6 = "#8a8a8a";
      color14 = "#8a8a8a";
      # White
      color7 = "#d4d4d4";
      color15 = "#ffffff";

      # Window
      window_padding_width = 8;
      background_opacity = "0.92";
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
    };
  };
}
