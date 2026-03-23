{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./kitty.nix
  ];

  home.username = "scttpr";
  home.homeDirectory = "/home/scttpr";

  home.packages = with pkgs; [
    # Wayland tools
    grim
    slurp
    wl-clipboard
    cliphist

    # Launchers & notifications
    wofi
    dunst

    # File manager
    nautilus

    # Media
    imv
    mpv
    pavucontrol

    # Work
    firefox
    kitty
    claude-code
  ];

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Shell
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#nixos";
      ll = "ls -la";
    };
  };

  # Git
  programs.git = {
    enable = true;
    userName = "scttpr";
  };

  home.stateVersion = "25.11";
}
