{ config, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
      };

      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];

      input-field = [{
        size = "250, 50";
        outline_thickness = 2;
        outer_color = "rgba(90, 90, 90, 1)";
        inner_color = "rgba(10, 10, 10, 0.9)";
        font_color = "rgba(212, 212, 212, 1)";
        fade_on_empty = true;
        placeholder_text = "";
        dots_center = true;
        position = "0, -20";
        halign = "center";
        valign = "center";
      }];

      label = [{
        text = "$TIME";
        color = "rgba(255, 255, 255, 1)";
        font_size = 64;
        font_family = "JetBrainsMono Nerd Font";
        position = "0, 80";
        halign = "center";
        valign = "center";
      }];
    };
  };

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 120;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
