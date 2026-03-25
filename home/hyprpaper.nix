{ config, pkgs, ... }:

let
  wallpaper = "/home/scttpr/.config/nixos/wallpaper.png";
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = wallpaper;
      wallpaper = ", ${wallpaper}";
      splash = false;
    };
  };
}
