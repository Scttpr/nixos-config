{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;

    settings = {
      global = {
        width = 350;
        height = 150;
        offset = "16x16";
        origin = "top-right";
        transparency = 10;
        frame_color = "#303030";
        frame_width = 2;
        corner_radius = 0;
        font = "JetBrainsMono Nerd Font 10";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        icon_theme = "Papirus-Dark";
        icon_position = "left";
        max_icon_size = 48;
        padding = 12;
        horizontal_padding = 16;
        gap_size = 4;
      };

      urgency_low = {
        background = "#0a0a0a";
        foreground = "#5a5a5a";
        frame_color = "#303030";
        timeout = 5;
      };

      urgency_normal = {
        background = "#0a0a0a";
        foreground = "#d4d4d4";
        frame_color = "#5a5a5a";
        timeout = 10;
      };

      urgency_critical = {
        background = "#0a0a0a";
        foreground = "#ffffff";
        frame_color = "#e55561";
        timeout = 0;
      };
    };
  };
}
