{ pkgs, ... }:

{
  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
    killUnconfinedConfinables = false;
    policies = {
      thunar = {
        state = "enforce";
        profile = ''
          abi <abi/3.0>,
          include <tunables/global>

          profile thunar ${pkgs.thunar}/bin/thunar flags=(enforce) {
            include <abstractions/base>
            include <abstractions/gtk>
            include <abstractions/fonts>
            include <abstractions/freedesktop.org>
            include <abstractions/nameservice>
            include <abstractions/dbus-session-strict>
            include <abstractions/dconf>
            include <abstractions/user-tmp>

            /nix/store/** mrix,

            owner @{HOME}/ r,
            owner @{HOME}/** rw,
            /tmp/** rw,
            owner /run/user/*/dconf/user rwk,
            owner /run/user/*/gvfs/ r,
            owner /run/user/*/gvfs/** rw,
            /run/user/*/bus rw,
            /run/mount/** r,
            /media/** rw,

            / r,
            /home/ r,

            owner @{PROC}/@{pid}/mountinfo r,
            owner @{PROC}/@{pid}/mounts r,
            owner @{PROC}/@{pid}/fd/ r,
            /etc/fstab r,
            /sys/devices/** r,

            deny /etc/shadow r,
            deny /etc/gshadow r,
          }
        '';
      };
      mpv = {
        state = "enforce";
        profile = ''
          abi <abi/3.0>,
          include <tunables/global>

          profile mpv ${pkgs.mpv}/bin/mpv flags=(enforce) {
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
        state = "enforce";
        profile = ''
          abi <abi/3.0>,
          include <tunables/global>

          profile imv ${pkgs.imv}/bin/imv flags=(enforce) {
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
}
