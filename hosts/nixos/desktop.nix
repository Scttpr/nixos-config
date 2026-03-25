{ pkgs, ... }:

{
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

  # ── Plymouth ──
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };
  boot.kernelParams = [ "quiet" "splash" ];

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

  # ── XDG portal ──
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];

  # ── Keyring ──
  services.gnome.gnome-keyring.enable = true;
}
