{ pkgs, ... }:

{
  # ── Kernel ──
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # ── Bluetooth ──
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # ── SSD TRIM ──
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

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
}
