{ config, lib, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./home.nix
        ./impermanence.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;

    time.timeZone = "Europe/Amsterdam";

    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.wayland.enable = true;
    programs.hyprland.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
    programs.fish.enable = true;

    users.mutableUsers = false;
    users.users.scttpr = {
        isNormalUser = true;
        initialHashedPassword = "<PASSWORD>";
        extraGroups = [ "wheel" "networkmanager" ];
        shell = pkgs.fish;
        packages = with pkgs; [
            firefox
            busybox
            htop
            jq
            waybar
            wofi
            xdg-desktop-portal-hyprland
            neofetch
        ];
    };

    environment.systemPackages = with pkgs; [
        neovim
        wget
    ];

    fonts.packages = with pkgs; [
        noto-fonts-emoji
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    systemd.tmpfiles.rules = [
        "d /persist/home 1755 scttpr users"
        "d /data/Personal 1755 scttpr users"
        "d /data/Work 1755 scttpr users"
        "d /data/Downloads 1755 scttpr users"
        "d /data/VMs 1755 scttpr users"
        "L /home/scttpr/Personal - - - - /data/Personal"
        "L /home/scttpr/Work - - - - /data/Work"
        "L /home/scttpr/Downloads - - - - /data/Downloads"
        "L /home/scttpr/VMs - - - - /data/VMs"
    ];

    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ "scttpr" ];

    system.stateVersion = "23.11";
}

