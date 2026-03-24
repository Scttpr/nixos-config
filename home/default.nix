{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./kitty.nix
    ./dunst.nix
    ./wofi.nix
    ./mpv.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./firefox.nix
  ];

  home.username = "scttpr";
  home.homeDirectory = "/home/scttpr";

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "radeonsi";
  };

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 24;
    gtk.enable = true;
  };

  # XDG user dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Opt into the new default: GTK4/libadwaita apps ignore gtk.theme,
  # so don't inherit it. Silences the stateVersion <26.05 warning.
  gtk.gtk4.theme = null;

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  home.packages = with pkgs; [
    # Polkit agent
    lxqt.lxqt-policykit
    # Fonts
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans

    # Wayland tools
    grim
    slurp
    wl-clipboard
    cliphist

    # File manager
    thunar
    thunar-volman

    # Backlight
    brightnessctl

    # Media
    imv
    pavucontrol
    playerctl

    # Work
    claude-code

    # CLI tools
    ripgrep
    fastfetch
  ];

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # ── Fastfetch ──
  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    logo = {
      type = "none";
    };
    display = {
      separator = "  ";
      color = {
        keys = "bright_white";
        output = "white";
      };
    };
    modules = [
      "break"
      { type = "title"; format = "{user-name}@{host-name}"; }
      "separator"
      { type = "os"; key = "os"; }
      { type = "kernel"; key = "ke"; }
      { type = "uptime"; key = "up"; }
      { type = "packages"; key = "pk"; }
      { type = "shell"; key = "sh"; }
      { type = "wm"; key = "wm"; }
      { type = "terminal"; key = "te"; }
      "break"
      { type = "cpu"; key = "cpu"; }
      { type = "gpu"; key = "gpu"; }
      { type = "memory"; key = "mem"; }
      { type = "disk"; key = "disk"; }
      { type = "battery"; key = "bat"; }
      "break"
    ];
  };

  # ── CLI tools ──
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--time-style=long-iso"
    ];
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
      style = "numbers,changes";
      italic-text = "always";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      vim_keys = true;
      shown_boxes = "cpu mem net proc";
      update_ms = 1000;
      proc_tree = true;
      clock_format = "%X";
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  # Shell
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" "erasedups" "ignorespace" ];
    historySize = 50000;
    historyFileSize = 50000;
    shellOptions = [ "histappend" "cmdhist" ];
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#nixos";

      # eza
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree --level=2";

      # bat
      cat = "bat --paging=never";
      less = "bat";

      # ripgrep
      rg = "rg --smart-case";
    };
    initExtra = ''
      # Fastfetch on new shell (skip in non-interactive contexts like scp)
      [[ $- == *i* ]] && fastfetch

      # Auto-logout after 15 min idle (interactive non-login shells)
      TMOUT=900
      readonly TMOUT

      # Completion behavior
      bind 'set show-all-if-ambiguous on'
      bind 'set completion-ignore-case on'
      bind 'set colored-stats on'
      bind 'set visible-stats on'
      bind 'set mark-symlinked-directories on'
      bind 'TAB:menu-complete'
      bind '"\\e[Z":menu-complete-backward'
    '';
    # History sync across shells — runs before starship's PROMPT_COMMAND
    bashrcExtra = ''
      __history_sync() { history -n; history -w; history -c; history -r; }
      PROMPT_COMMAND="__history_sync;$PROMPT_COMMAND"
    '';
  };

  # Direnv — auto-load devShells on cd
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$character";
      username = {
        show_always = true;
        style_user = "white";
        format = "[$user]($style)@";
      };
      hostname = {
        ssh_only = false;
        style = "dimmed white";
        format = "[$hostname]($style) ";
      };
      character = {
        success_symbol = "[→](white)";
        error_symbol = "[✗](red)";
      };
      directory = {
        style = "white";
        truncation_length = 3;
      };
      git_branch = {
        style = "dimmed white";
        format = "[$branch]($style) ";
      };
      git_status = {
        style = "dimmed white";
        format = "[$all_status$ahead_behind]($style) ";
      };
      nix_shell = {
        style = "dimmed white";
        format = "[nix]($style) ";
      };
    };
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "scttpr";
      user.email = "git.reformer354@passmail.net";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  home.stateVersion = "25.11";
}
