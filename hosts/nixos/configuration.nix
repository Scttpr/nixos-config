{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ── Nix ──
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "root" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # ── Boot ──
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    kernelParams = [
      "quiet"
      "splash"
      "page_alloc.shuffle=1"
      "slab_nomerge"
    ];

    blacklistedKernelModules = [
      # Rare network protocols
      "dccp" "sctp" "rds" "tipc" "n-hdlc" "ax25" "netrom" "x25" "rose"
      "decnet" "econet" "af_802154" "ipx" "appletalk" "psnap" "p8023" "p8022"
      # Firewire (DMA attack vector)
      "firewire-core" "firewire-ohci" "firewire-sbp2" "firewire-net"
      # Rare filesystems
      "cramfs" "freevxfs" "jffs2" "hfs" "hfsplus" "squashfs" "udf"
      # Misc
      "vivid"
    ];

    kernel.sysctl = {
      # Network hardening
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_timestamps" = 0;

      # Memory hardening
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.perf_event_paranoid" = 3;
      "kernel.yama.ptrace_scope" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
      "kernel.unprivileged_userns_clone" = 1;
      "vm.swappiness" = 10;
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;

      # Restrict loading of line disciplines
      "dev.tty.ldisc_autoload" = 0;
    };

    tmp.useTmpfs = true;
  };

  # ── Network ──
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.macAddress = "stable";
      ethernet.macAddress = "stable";
      settings.connection."ipv6.ip6-privacy" = 2;
    };
    firewall = {
      enable = true;
      logRefusedConnections = true;
    };
  };

  # ── Encrypted DNS ──
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
      ];
      FallbackDNS = [
        "1.1.1.1#cloudflare-dns.com"
      ];
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
    };
  };

  # ── Security ──
  security = {
    polkit.enable = true;
    sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults timestamp_timeout=15
        Defaults passwd_timeout=1
        Defaults env_reset
      '';
    };
    pam.services.greetd.enableGnomeKeyring = true;
    pam.services.greetd.logFailures = true;
    pam.services.sudo.logFailures = true;
  };

  # ── AppArmor ──
  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
    killUnconfinedConfinables = false;
  };

  # Disable core dumps
  security.pam.loginLimits = [
    { domain = "*"; type = "hard"; item = "core"; value = "0"; }
  ];
  environment.shellInit = "umask 077";
  systemd.coredump.extraConfig = "Storage=none";

  # ── Audit ──
  security.auditd.enable = true;
  security.audit = {
    enable = true;
    rules = [
      "-a exit,always -F arch=b64 -S execve -k exec"
      "-w /etc/shadow -p wa -k shadow"
      "-w /etc/passwd -p wa -k passwd"
    ];
  };

  # ── Proc hidepid ──
  fileSystems."/proc" = {
    device = "proc";
    fsType = "proc";
    options = [ "hidepid=2" "gid=${toString config.users.groups.wheel.gid}" ];
  };

  # ── SSD TRIM ──
  services.fstrim = {
    enable = true;
    interval = "weekly";
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

  # ── Firmware ──
  hardware.enableRedistributableFirmware = true;

  # ── GPU / Hardware acceleration ──
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # ── Hyprland ──
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # ── Login manager ──
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  # ── Lid switch ──
  services.logind.settings.Login = {
    HandleLidSwitch = "lock";
    HandleLidSwitchExternalPower = "lock";
  };

  # ── Audio ──
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ── Bluetooth ──
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # ── Backlight ──
  hardware.acpilight.enable = true;

  # ── Power management ──
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

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
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
  };

  # ── XDG portal ──
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # ── Keyring ──
  services.gnome.gnome-keyring.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

  # System-level packages only — user packages go in home-manager
  environment.systemPackages = with pkgs; [
    wget
    git
    neovim
    libva-utils
  ];

  system.stateVersion = "25.11";
}
