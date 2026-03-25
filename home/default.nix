{ config, pkgs, rtk-pkg, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./kitty.nix
    ./dunst.nix
    ./wofi.nix
    ./mpv.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./firefox.nix
    ./shell.nix
    ./git.nix
    ./cli.nix
    ./claude.nix
  ];

  home.username = "scttpr";
  home.homeDirectory = "/home/scttpr";

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "radeonsi";
    RTK_TELEMETRY_DISABLED = "1";
  };

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 24;
    gtk.enable = true;
  };

  # XDG user dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Opt into the new default: GTK4/libadwaita apps ignore gtk.theme,
  # so don't inherit it. Silences the stateVersion <26.05 warning.
  gtk.gtk4.theme = null;

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  home.packages = with pkgs; [
    # Polkit agent
    lxqt.lxqt-policykit
    # Fonts
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans

    # Wayland tools
    grim
    slurp
    wl-clipboard
    cliphist

    # File manager
    thunar
    thunar-volman

    # Backlight
    brightnessctl

    # Media
    imv
    pavucontrol
    playerctl

    # Work
    claude-code

    # CLI tools
    jq
    ripgrep
    fastfetch
    rtk-pkg
  ];

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
