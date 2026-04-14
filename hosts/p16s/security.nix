{ config, ... }:

{
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

  # Disable core dumps
  security.pam.loginLimits = [
    { domain = "*"; type = "hard"; item = "core"; value = "0"; }
  ];
  environment.shellInit = "umask 077";
  systemd.coredump.extraConfig = "Storage=none";

  # ── Kernel hardening ──
  boot.blacklistedKernelModules = [
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

  boot.kernelParams = [
    "page_alloc.shuffle=1"
    "slab_nomerge"
  ];

  boot.kernel.sysctl = {
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

  # ── Proc hidepid ──
  fileSystems."/proc" = {
    device = "proc";
    fsType = "proc";
    options = [ "hidepid=2" "gid=${toString config.users.groups.wheel.gid}" ];
  };
}
