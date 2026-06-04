{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";

    settings = {
      monitor = [
        "eDP-1, 1920x1200@60, 3840x1080, 1"
        "DP-10, 1920x1080@60, 2880x0, 1"
        "DP-8, 1920x1080@60, 4800x0, 1"
      ];

      exec-once = [
        "lxqt-policykit-agent"
        "dunst"
        "wl-paste --type text --watch bash -c 'cliphist store -max-items 20; sleep 10 && wl-copy --clear'"
        "wl-paste --type image --watch cliphist store -max-items 20"
      ];

      env = [
        "XCURSOR_SIZE, 24"
        "XCURSOR_THEME, phinger-cursors-light"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          "tap-to-click" = true;
          drag_lock = true;
          disable_while_typing = true;
        };
        sensitivity = 0;
      };

      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgba(ffffffff)";
        "col.inactive_border" = "rgba(303030ff)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
        };
        shadow = {
          enabled = true;
          range = 8;
          render_power = 2;
          color = "rgba(000000ee)";
        };
      };

      animations = {
        enabled = true;
        bezier = "ease, 0.25, 0.1, 0.25, 1";
        animation = [
          "windows, 1, 4, ease, slide"
          "windowsOut, 1, 4, ease, slide"
          "fade, 1, 3, ease"
          "workspaces, 1, 3, ease, slide"
        ];
      };

      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      windowrule = [
        "float on, match:class ^(pavucontrol)$"
        "float on, match:class ^(nm-connection-editor)$"
        "float on, match:title ^(Open File)$"
        "float on, match:title ^(Save File)$"
      ];

      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive,"
        "$mod SHIFT, M, exit,"
        "$mod SHIFT, L, exec, loginctl lock-session"
        "$mod, V, togglefloating,"
        "$mod, D, exec, wofi --show drun"
        "$mod, P, pseudo,"
        "$mod, T, layoutmsg, togglesplit"
        "$mod, F, fullscreen, 0"

        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"

        "$mod, C, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "$mod SHIFT, C, exec, cliphist wipe && notify-send 'Clipboard wiped'"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

}
