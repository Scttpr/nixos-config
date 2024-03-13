{ config, lib, pkgs, ... }:
let
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
    imports = [
        "${home-manager}/nixos"
    ];

    home-manager.users.scttpr = {
        imports = [
            ./home/wm.nix
            ./home/shell.nix
            ./home/programs.nix
            ./home/vim.nix
            ./home/impermanence.nix
        ];

        home = {
            stateVersion = "23.11";
            username = "scttpr";
            homeDirectory = "/home/scttpr";
        };

        programs.home-manager.enable = true;
    };
}
