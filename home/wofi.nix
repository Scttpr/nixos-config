{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      width = 500;
      height = 400;
      prompt = "Search...";
      insensitive = true;
      allow_images = true;
      image_size = 24;
    };

    style = ''
      window {
        background-color: rgba(10, 10, 10, 0.95);
        border: 2px solid #303030;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        color: #d4d4d4;
      }

      #input {
        background-color: #141414;
        color: #d4d4d4;
        border: none;
        border-radius: 0;
        padding: 8px 12px;
        margin: 8px;
      }

      #outer-box {
        margin: 4px;
      }

      #scroll {
        margin: 0 8px 8px 8px;
      }

      #entry {
        padding: 6px 8px;
        border-radius: 0;
      }

      #entry:selected {
        background-color: rgba(255, 255, 255, 0.1);
        color: #ffffff;
      }

      #text {
        color: #d4d4d4;
      }

      #text:selected {
        color: #ffffff;
      }
    '';
  };
}
