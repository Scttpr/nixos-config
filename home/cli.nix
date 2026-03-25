{ pkgs, ... }:

{
  # ── Eza ──
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--time-style=long-iso"
    ];
  };

  # ── Bat ──
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
      style = "numbers,changes";
      italic-text = "always";
    };
  };

  # ── Btop ──
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
}
