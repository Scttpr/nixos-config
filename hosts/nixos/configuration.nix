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
      extra-sandbox-paths = [ "/run/systemd/resolve" ];
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
      "vm.swappiness" = 10;
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;

      # Restrict loading of line disciplines
      "dev.tty.ldisc_autoload" = 0;
    };

    # /tmp mount hardened via fileSystems below
  };

  # ── Network ──
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.macAddress = "stable";
      ethernet.macAddress = "stable";
      settings.connection."ipv6.ip6-privacy" = 2;
      dispatcherScripts = [{
        # Disable wifi when ethernet connects, re-enable when it disconnects
        type = "basic";
        source = pkgs.writeText "wifi-toggle" ''
          IFACE=$1
          ACTION=$2
          case "$IFACE" in
            e*)
              case "$ACTION" in
                up)   nmcli radio wifi off ;;
                down) nmcli radio wifi on ;;
              esac
              ;;
          esac
        '';
      }];
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
        Defaults timestamp_timeout=5
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
    policies = {
      thunar = {
        state = "complain";
        profile = ''
          abi <abi/3.0>,
          include <tunables/global>

          profile thunar ${pkgs.thunar}/bin/thunar flags=(complain) {
            include <abstractions/base>
            include <abstractions/gtk>
            include <abstractions/fonts>
            include <abstractions/freedesktop.org>
            include <abstractions/nameservice>
            include <abstractions/dbus-session-strict>
            include <abstractions/user-tmp>

            owner @{HOME}/** rw,
            /tmp/** rw,
            /run/user/*/gvfs/** r,
            /run/mount/** r,
            /media/** rw,

            @{PROC}/self/mountinfo r,
            /etc/fstab r,
            /sys/devices/** r,

            deny /etc/shadow r,
            deny /etc/gshadow r,
          }
        '';
      };
      mpv = {
        state = "complain";
        profile = ''
          abi <abi/3.0>,
          include <tunables/global>

          profile mpv ${pkgs.mpv}/bin/mpv flags=(complain) {
            include <abstractions/base>
            include <abstractions/audio>
            include <abstractions/fonts>
            include <abstractions/freedesktop.org>
            include <abstractions/nameservice>
            include <abstractions/user-tmp>
            include <abstractions/X>

            owner @{HOME}/** r,
            /tmp/** rw,
            /media/** r,
            /run/user/*/pulse/ r,
            /run/user/*/pipewire-* rw,

            /dev/dri/** rw,
            /dev/video* r,
            @{sys}/devices/** r,
            @{PROC}/self/fd/ r,

            deny network,
            deny /etc/shadow r,
          }
        '';
      };
      imv = {
        state = "complain";
        profile = ''
          abi <abi/3.0>,
          include <tunables/global>

          profile imv ${pkgs.imv}/bin/imv flags=(complain) {
            include <abstractions/base>
            include <abstractions/fonts>
            include <abstractions/freedesktop.org>
            include <abstractions/user-tmp>
            include <abstractions/X>

            owner @{HOME}/** r,
            /tmp/** r,
            /media/** r,

            /dev/dri/** rw,
            @{sys}/devices/** r,

            deny network,
            deny /etc/shadow r,
          }
        '';
      };
    };
  };

  # Disable core dumps
  security.pam.loginLimits = [
    { domain = "*"; type = "hard"; item = "core"; value = "0"; }
  ];
  environment.shellInit = "umask 077";
  systemd.coredump.extraConfig = "Storage=none";

  # ── USBGuard ──
  services.usbguard = {
    enable = true;
    presentDevicePolicy = "allow";
    insertedDevicePolicy = "apply-policy";
    rules = ''
      # Internal xHCI host controllers
      allow id 1d6b:0002 serial "0000:64:00.3" name "xHCI Host Controller" hash "itWJ0jdmwMTs9EuQmilJnh3Dqny0qDjLh6uoalee/iA=" parent-hash "ryoMvjbC6VLMLjh5woggxNI1CyBOBrW412dC+GQeis4=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:64:00.3" name "xHCI Host Controller" hash "ZKxM+7dxDciy3g3O2pepNp7X8wA+HpSN7xVtLHXc4co=" parent-hash "ryoMvjbC6VLMLjh5woggxNI1CyBOBrW412dC+GQeis4=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0002 serial "0000:64:00.4" name "xHCI Host Controller" hash "ujCE8JWIJdTAJRvL/4n+fCq2MXbiyaoMP3bKdi9gNw0=" parent-hash "zV0Qd1O0FR2D+xD0beveBoeL0DCYMC3IG1aMgbIxtY4=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:64:00.4" name "xHCI Host Controller" hash "cqJt8igTeH2CEToZjmbz6i14h8d0a/xuKJE+n6DXSIM=" parent-hash "zV0Qd1O0FR2D+xD0beveBoeL0DCYMC3IG1aMgbIxtY4=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0002 serial "0000:66:00.3" name "xHCI Host Controller" hash "BqCcbGYRx9WmbXX9O6Y0JhiJwrGi2G82+qK6S5WKe/c=" parent-hash "JJj6P0xwAW1xW7LT0pyC91C4W/KvHY/iYsoBDBh/YQU=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:66:00.3" name "xHCI Host Controller" hash "fdLdRS+5HvC54P/P4jKmsjDbDON4debmmBzsit2M3pc=" parent-hash "JJj6P0xwAW1xW7LT0pyC91C4W/KvHY/iYsoBDBh/YQU=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0002 serial "0000:66:00.4" name "xHCI Host Controller" hash "6FTa+djr2ks6Uu4PohzW3J9hoYoYKdl4r+g5mKkqsN8=" parent-hash "rUASZM2vB9X4K33KMdxaQ+JWmCxgq1ETQ6dJUef8Iug=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:66:00.4" name "xHCI Host Controller" hash "y877eh4B1ubmW70ajDkw6f2RPrbeCXAdEnZrv/FSmy0=" parent-hash "rUASZM2vB9X4K33KMdxaQ+JWmCxgq1ETQ6dJUef8Iug=" with-interface 09:00:00 with-connect-type ""

      # Internal USB2.0 hub
      allow id 05e3:0610 serial "" name "USB2.0 Hub" hash "HtK/V9+iwK2EoOneULC1IMFJ2IxQr0rL9Q+N6BDFNak=" parent-hash "itWJ0jdmwMTs9EuQmilJnh3Dqny0qDjLh6uoalee/iA=" via-port "1-3" with-interface { 09:00:01 09:00:02 } with-connect-type "not used"

      # Integrated camera
      allow id 5986:118c serial "200901010001" name "Integrated Camera" hash "oJaf2cO4/bicpViHny8S/8CPNuUr78mUkUcOWzpFrRE=" parent-hash "ujCE8JWIJdTAJRvL/4n+fCq2MXbiyaoMP3bKdi9gNw0=" with-interface { 0e:01:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:01:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 fe:01:01 } with-connect-type "not used"

      # USB dock (hub pair)
      allow id 2109:2817 serial "000000000" name "USB2.0 Hub             " hash "qPtI8AWo/sxA1ywaz0q3rn4T+Boz5sTPIjyhJMfZbDk=" parent-hash "BqCcbGYRx9WmbXX9O6Y0JhiJwrGi2G82+qK6S5WKe/c=" with-interface { 09:00:01 09:00:02 } with-connect-type "hotplug"
      allow id 2109:0817 serial "000000000" name "USB3.0 Hub             " hash "noU8ynIKcqoDHeEoHF36V/ZFF1tRfYSq6JBT4bh30EY=" parent-hash "fdLdRS+5HvC54P/P4jKmsjDbDON4debmmBzsit2M3pc=" with-interface 09:00:00 with-connect-type "hotplug"

      # Anker 364 dock + internal hub + ethernet
      allow id 05e3:0608 serial "" name "USB2.0 Hub" hash "Xx4NMpaW1qI7RdzCbvAFz0fkV85X3YiKSWc2anf6A7w=" parent-hash "qPtI8AWo/sxA1ywaz0q3rn4T+Boz5sTPIjyhJMfZbDk=" via-port "5-1.3" with-interface 09:00:00 with-connect-type "unknown"
      allow id 291a:83a2 serial "AHC26G0D37200928" name "Anker 364 USB C Hub(10-in-1, Dual 4K HDMI)" hash "UHXad4YnThXXmdUp8X3ZlD0cnbq6R69Y0HeKHmG8bQU=" parent-hash "qPtI8AWo/sxA1ywaz0q3rn4T+Boz5sTPIjyhJMfZbDk=" with-interface 11:00:00 with-connect-type "unknown"
      allow id 0bda:8153 serial "001300E04C9F3DE8" name "USB 10/100/1000 LAN" hash "7xhgDlKCOXCiAiv3ixA6HKE9iK7KHmhmD+uYWO7CtCg=" parent-hash "noU8ynIKcqoDHeEoHF36V/ZFF1tRfYSq6JBT4bh30EY=" with-interface { ff:ff:00 02:06:00 0a:00:00 0a:00:00 } with-connect-type "unknown"

      # Internal hub devices (Bluetooth/smartcard)
      allow id 10ab:9309 serial "" name "" hash "whHOIdQrSVT8iQWv1Bg5SSP7oI4SXttsMYptqf04kXs=" parent-hash "HtK/V9+iwK2EoOneULC1IMFJ2IxQr0rL9Q+N6BDFNak=" via-port "1-3.1" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "not used"
      allow id 2ce3:9563 serial "" name "EMV Smartcard Reader" hash "SOxag+v/yr7SA04eNCa88HFqD0IhMbIt2Vk0jDIs21A=" parent-hash "HtK/V9+iwK2EoOneULC1IMFJ2IxQr0rL9Q+N6BDFNak=" via-port "1-3.2" with-interface 0b:00:00 with-connect-type "not used"
    '';
  };

  # ── Tmpfs hardening ──
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults" "nosuid" "nodev" "mode=1777" "size=50%" ];
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
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
  };

  # ── XDG portal ──
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];

  # ── Keyring ──
  services.gnome.gnome-keyring.enable = true;

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
