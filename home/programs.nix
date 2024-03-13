{ pkgs, config, lib, ... }:
{
    programs = {
        git = {
            enable = true;
            userName = "scttpr";
            userEmail = "<EMAIL>";
            # define signing
            extraConfig = {
                init = {
                    defaultBranch = "main";
                };
                push = {
                    autoSetupRemote = true;
                };
            };
        };
    };
}
