{ user, ... }:

{
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ user ];
      keepEnv = true;   # preserve PATH/HOME for nixos-rebuild
      persist = true;
    }];
  };
  environment.shellAliases.sudo = "doas";

  # authfile deployed out-of-band (not in this public repo); place at the path below.
  security.pam.u2f = {
    enable = true;
    settings = {
      authfile = "/var/lib/u2f/u2f-mappings";
      cue = true;
      interactive = true;
    };
  };

  # unixAuth = false removes the password path entirely.
  security.pam.services.greetd = {
    u2fAuth = true;
    unixAuth = false;
  };
  security.pam.services.hyprlock = {
    u2fAuth = true;
    unixAuth = false;
  };
  security.pam.services.login = {
    u2fAuth = true;
    unixAuth = false;
  };
  security.pam.services.doas = {
    u2fAuth = true;
    unixAuth = false;
  };
  security.pam.services.polkit-1 = {
    u2fAuth = true;
    unixAuth = false;
  };
}
