{ config, pkgs, rtk-pkg, user, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./kitty.nix
    ./dunst.nix
    ./wofi.nix
    ./mpv.nix
    ./hyprlock.nix
    ./firefox.nix
    ./chromium.nix
    ./shell.nix
    ./git.nix
    ./nvim.nix
    ./cli.nix
    ./claude.nix
    ./taskwarrior.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

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

  # GTK4/libadwaita apps ignore gtk.theme; null silences the stateVersion <26.05 warning
  gtk.gtk4.theme = null;

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    icon-theme = "Papirus-Dark";
    gtk-theme = "Adwaita-dark";
  };

  home.packages = with pkgs; [
    lxqt.lxqt-policykit
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans

    grim
    slurp
    wl-clipboard
    cliphist

    # needed in XDG_DATA_DIRS for wofi
    papirus-icon-theme
    librsvg

    thunar
    thunar-volman
    glib

    brightnessctl

    imv
    pavucontrol
    playerctl

    speedcrunch

    claude-code
    obsidian

    ouch
    jq
    ripgrep
    fastfetch
    rtk-pkg
    taskwarrior-tui
    gpg-tui
    broot
    glow
  ];

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
