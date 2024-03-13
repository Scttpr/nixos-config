{ pkgs, config, lib, ... }:
{
    programs = {
        alacritty = {
            enable = true;
            settings = {
                env.TERM = "xterm-256color";
                window.padding = {
                    x = 10;
                    y=10;
                };
                window.decorations = "none";
                window.opacity = 0.7;
                scrolling.history = 1000;
                font = {
                    normal = {
                        family = "FiraCode Nerd Font";
                        style = "Regular";
                    };
                    bold = {
                        family = "FiraCode Nerd Font";
                        style = "Bold";
                    };
                    italic = {
                        family = "FiraCode Nerd Font";
                        style = "Italic";
                    };
                    size = 12;
                };
            };
        };


        fish = {
            enable = true;
            interactiveShellInit = ''
                set fish_greeting

                starship init fish | source
                '';
        };

        starship = {
            enable = true;
            settings = {
                character = {
                    success_symbol = "[➜](bold green)";
                };
                username = {
                    show_always = true;
                };
                hostname = {
                    ssh_only = false;
                };
            };
        };
    };
}
