{ ... }:

{
  modules.hardening.enable = true;

  security = {
    polkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
    pam.services.greetd.logFailures = true;
    pam.services.doas.logFailures = true;
  };
}
