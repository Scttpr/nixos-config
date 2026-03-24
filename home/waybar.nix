{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = [{
      layer = "top";
      position = "top";
      height = 34;
      spacing = 8;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
      };

      clock = {
        format = "{:%H:%M  %a %d %b}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon}  {capacity}%";
        format-charging = "󰂄  {capacity}%";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };

      network = {
        format-wifi = "󰤨  {essid}";
        format-ethernet = "󰈀  Wired";
        format-disconnected = "󰤭  Off";
        tooltip-format = "{ifname}: {bandwidthTotalBytes}";
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "󰝟  Muted";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "pavucontrol";
      };

      tray = {
        spacing = 8;
      };
    }];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(10, 10, 10, 0.9);
        color: #d4d4d4;
      }

      #workspaces button {
        padding: 0 8px;
        color: #5a5a5a;
        border: none;
        border-radius: 0;
      }

      #workspaces button.active {
        color: #ffffff;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.08);
      }

      #clock,
      #battery,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 12px;
      }

      #battery.warning {
        color: #e5a230;
      }

      #battery.critical {
        color: #e55561;
      }

      #network.disconnected {
        color: #5a5a5a;
      }

      #pulseaudio.muted {
        color: #5a5a5a;
      }
    '';
  };
}
