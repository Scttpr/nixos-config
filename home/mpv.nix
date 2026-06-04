{ config, pkgs, ... }:

{
  programs.mpv = {
    enable = true;

    config = {
      hwdec = "auto-safe";
      vo = "gpu-next";
      gpu-context = "wayland";
      keep-open = true;
      osd-font = "JetBrainsMono Nerd Font";
      osd-font-size = 24;
    };
  };
}
