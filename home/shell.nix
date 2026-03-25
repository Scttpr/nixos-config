{ ... }:

{
  # ── Bash ──
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

  # ── Direnv ──
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ── Zoxide ──
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  # ── Starship prompt ──
  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$env_var_DIRENV_DIR$character";
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
      env_var.DIRENV_DIR = {
        style = "dimmed white";
        format = "[direnv]($style) ";
      };
    };
  };
}
