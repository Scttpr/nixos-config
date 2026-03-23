{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      # Font
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;

      # Tokyo Night Storm theme
      foreground = "#c0caf5";
      background = "#1a1b26";
      selection_foreground = "#c0caf5";
      selection_background = "#33467c";
      cursor = "#c0caf5";

      # Black
      color0 = "#15161e";
      color8 = "#414868";
      # Red
      color1 = "#f7768e";
      color9 = "#f7768e";
      # Green
      color2 = "#9ece6a";
      color10 = "#9ece6a";
      # Yellow
      color3 = "#e0af68";
      color11 = "#e0af68";
      # Blue
      color4 = "#7aa2f7";
      color12 = "#7aa2f7";
      # Magenta
      color5 = "#bb9af7";
      color13 = "#bb9af7";
      # Cyan
      color6 = "#7dcfff";
      color14 = "#7dcfff";
      # White
      color7 = "#a9b1d6";
      color15 = "#c0caf5";

      # Window
      window_padding_width = 8;
      background_opacity = "0.92";
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
    };
  };
}
