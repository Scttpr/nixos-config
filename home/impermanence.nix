{ config, pkgs, ... }:
let
    impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
    imports = [ "${impermanence}/home-manager.nix" ];

    home.persistence."/persist/home" = {
        removePrefixDirectory = true;
        allowOther = true;
        directories = [
            "firefox/.mozilla"
            "ssh/.ssh"
        ];
        files = [
            "fish/.local/share/fish/fish_history"   
            "virtualbox/.config/VirtualBox/VirtualBox.xml"
        ];
    };
}
