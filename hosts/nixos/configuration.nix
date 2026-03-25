{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./security.nix
    ./apparmor.nix
    ./usbguard.nix
    ./networking.nix
    ./hardware.nix
    ./desktop.nix
  ];

  # ── Nix ──
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "root" ];
      extra-sandbox-paths = [ "/run/systemd/resolve" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # ── Boot ──
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # ── Tmpfs hardening ──
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults" "nosuid" "nodev" "mode=1777" "size=50%" ];
  };

  # ── OOM protection ──
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };

  # ── Journald ──
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=1month
  '';

  # ── Timezone and locale ──
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # ── User ──
  users.users.scttpr = {
    isNormalUser = true;
    description = "scttpr";
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

  # System-level packages only — user packages go in home-manager
  environment.systemPackages = with pkgs; [
    wget
    neovim
    libva-utils
  ];

  system.stateVersion = "25.11";
}
