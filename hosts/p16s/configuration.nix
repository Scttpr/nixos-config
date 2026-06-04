{ config, pkgs, lib, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./security.nix
    ./auth.nix
    ./apparmor.nix
    ./usbguard.nix
    ./networking.nix
    ./hardware.nix
    ./desktop.nix
  ];

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

  # lanzaboote replaces systemd-boot to produce signed UKIs for Secure Boot.
  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    systemd-boot.editor = false;
    efi.canTouchEfiVariables = true;
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  zramSwap.enable = true;
  # Overrides swappiness=10 from hardening.nix; zram is cheap to swap to.
  boot.kernel.sysctl."vm.swappiness" = lib.mkForce 180;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=1month
  '';

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

  hardware.rtl-sdr.enable = true;

  hardware.nitrokey.enable = true;

  # UID/GIDs pinned so ownership survives a tmpfs root.
  users.users.${user} = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    description = user;
    extraGroups = [ "networkmanager" "wheel" "video" "input" "plugdev" "nitrokey" ];
  };

  users.groups = {
    users.gid = 100;
    wheel.gid = 1;
    video.gid = 26;
    networkmanager.gid = 57;
    input.gid = 174;
    plugdev.gid = 991;
    nitrokey.gid = 992;
  };

  # Deterministic machine-id so journald/dbus identity survives a tmpfs root.
  environment.etc."machine-id".text = "f9668b9a70cb4d0a9a2fdd7798f12134\n";

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "obsidian"
    ];

  environment.systemPackages = with pkgs; [
    wget
    neovim       # root recovery editor; user's nvim is via home-manager
    libva-utils
    sbctl
  ];

  system.stateVersion = "25.11";
}
