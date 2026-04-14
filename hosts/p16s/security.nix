{ ... }:

{
  # Reusable hardening from modules/hardening.nix
  modules.hardening.enable = true;

  # Host-specific PAM
  security = {
    polkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
    pam.services.greetd.logFailures = true;
    pam.services.sudo.logFailures = true;
  };
}
