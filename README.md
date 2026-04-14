# nixos

Declarative NixOS + Home Manager flake for a single x86_64-linux workstation.
Follows nixpkgs-unstable. Wayland-first (Hyprland), monochrome aesthetic.

## Structure

```
flake.nix                           Flake entry point, dev shells, custom packages
modules/
  hardening.nix                     Reusable workstation hardening (importable via nixosModules.hardening)
hosts/p16s/
  configuration.nix                 Boot, locale, GC, earlyoom, user account
  hardware-configuration.nix        Generated hardware scan (LUKS, AMD)
  hardware.nix                      GPU, bluetooth, TLP power management, SSD TRIM
  security.nix                      Host-specific PAM config, enables hardening module
  apparmor.nix                      Enforce profiles for thunar, mpv, imv
  usbguard.nix                      USB device whitelist (hash-pinned)
  networking.nix                    NetworkManager, firewall, WireGuard VPN, encrypted DNS
  desktop.nix                       Hyprland/UWSM, greetd, PipeWire, XDG portals
home/
  default.nix                       User env, GTK/cursor theme, core packages
  shell.nix                         Bash, direnv, zoxide, starship prompt
  cli.nix                           Eza, bat, btop, fastfetch
  hyprland.nix                      Compositor keybinds, monitors, input, appearance
  waybar.nix                        Top bar modules and styling
  kitty.nix                         Terminal emulator
  firefox.nix                       Privacy hardening, containers, extensions
  git.nix                           SSH commit signing
  claude.nix                        Claude Code hooks and permissions
  taskwarrior.nix                   Task manager
  hyprlock.nix / hyprpaper.nix      Lock screen and wallpaper
  dunst.nix / wofi.nix / mpv.nix    Notifications, launcher, media player
```

## Hardening module

The security hardening is extracted into a standalone NixOS module that can be imported independently:

```nix
{
  inputs.nixos-scttpr.url = "github:scttpr/nixos";

  outputs = { nixos-scttpr, ... }: {
    nixosConfigurations.myhost = {
      modules = [
        nixos-scttpr.nixosModules.hardening
        { modules.hardening.enable = true; }
      ];
    };
  };
}
```

This enables: kernel module blacklist, sysctl hardening (network + memory + process), proc hidepid, tmpfs hardening, core dump disabling, umask 077, and sudo lockdown. See `modules/hardening.nix` for details.

## Security

- **Kernel**: module blacklist (firewire, rare protocols/filesystems), ASLR hardening, ptrace/dmesg/kptr restrictions, BPF disabled for unprivileged, slab_nomerge
- **Network**: firewall with connection logging, ICMP/redirect hardening, TCP syncookies, encrypted DNS (Quad9 DoT via systemd-resolved), MAC randomization, IPv6 privacy extensions
- **Disk**: full LUKS encryption (root + swap)
- **AppArmor**: enforce mode on file manager and media apps
- **USBGuard**: whitelist-only policy with hash-pinned devices
- **Process isolation**: hidepid=2, core dumps disabled, umask 077
- **Sudo**: wheel-only, 5-min timeout, env_reset
- **Browser**: HTTPS-only, resistFingerprinting, TLS 1.2+, OCSP, container isolation, no telemetry, speculative connections disabled
- **Shell**: auto-logout after 15 min idle, clipboard auto-clear

## Dev Shells

```sh
nix develop .#rust          # Rust toolchain (rustc, cargo, analyzer, clippy)
nix develop .#netsec        # Pentesting (nmap, metasploit, burp, wireshark)
nix develop .#binanalysis   # Reverse engineering (radare2, gdb/gef, yara)
nix develop .#hamradio      # SDR and digital modes (sdrpp, wsjtx, gnuradio)
nix develop .#llm           # Local AI (ollama, aichat, python3, uv)
```

## Forking

This config is designed for a single machine. To adapt it:

1. Change `user` in `flake.nix` (single variable, propagated everywhere)
2. Rename `hosts/p16s/` to your machine and update the `nixosConfigurations` key in `flake.nix`
3. Replace `hardware-configuration.nix` with your own (`nixos-generate-config`)
4. Replace USBGuard rules in `hosts/p16s/usbguard.nix` (`usbguard generate-policy`)
5. Update WireGuard config in `hosts/p16s/networking.nix`
6. Update monitor config in `home/hyprland.nix`
7. Update git identity in `home/git.nix`

## Usage

```sh
sudo nixos-rebuild switch --flake .#p16s       # Apply configuration
sudo nixos-rebuild dry-build --flake .#p16s    # Verify without applying
nix flake check                                 # Validate flake
nix fmt                                         # Format nix files
```

## License

MIT
