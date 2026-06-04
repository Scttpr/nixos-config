{ config, lib, ... }:

let
  cfg = config.modules.hardening;
in
{
  options.modules.hardening = {
    enable = lib.mkEnableOption "workstation security hardening";
  };

  config = lib.mkIf cfg.enable {

    boot.blacklistedKernelModules = [
      "dccp" "sctp" "rds" "tipc" "n-hdlc" "ax25" "netrom" "x25" "rose"
      "decnet" "econet" "af_802154" "ipx" "appletalk" "psnap" "p8023" "p8022"
      # Firewire (DMA attack vector)
      "firewire-core" "firewire-ohci" "firewire-sbp2" "firewire-net"
      "cramfs" "freevxfs" "jffs2" "hfs" "hfsplus" "squashfs" "udf"
      "vivid"
    ];

    boot.kernelParams = [
      "page_alloc.shuffle=1"
      "slab_nomerge"
    ];

    boot.kernel.sysctl = {
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

      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.perf_event_paranoid" = 3;
      "kernel.yama.ptrace_scope" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
      "vm.swappiness" = 10;
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;

      "dev.tty.ldisc_autoload" = 0;
    };

    fileSystems."/proc" = {
      device = "proc";
      fsType = "proc";
      options = [ "hidepid=2" "gid=${toString config.users.groups.wheel.gid}" ];
    };

    fileSystems."/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "nosuid" "nodev" "mode=1777" "size=50%" ];
    };

    security.pam.loginLimits = [
      { domain = "*"; type = "hard"; item = "core"; value = "0"; }
    ];
    systemd.coredump.settings.Coredump.Storage = "none";

    environment.shellInit = "umask 077";

    # Escalation (doas) and its hardening live in hosts/p16s/auth.nix; sudo is disabled there.
  };
}
