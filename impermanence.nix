{ config, lib, pkgs, ... }:
let
    impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
    imports = [
        "${impermanence}/nixos.nix"
    ];

    programs.fuse.userAllowOther = true;

    environment.persistence."/persist" = {
        hideMounts = true;
        directories = [
            "/var/lib/bluetooth"
            "/etc/NetworkManager/system-connections"
        ];
    };
}

