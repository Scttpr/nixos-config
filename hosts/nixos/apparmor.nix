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
