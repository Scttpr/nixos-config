{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${config.home.homeDirectory}/.config/nixos/wallpaper.png" ];
      wallpaper = [ ", ${config.home.homeDirectory}/.config/nixos/wallpaper.png" ];
      splash = false;
    };
  };
}
