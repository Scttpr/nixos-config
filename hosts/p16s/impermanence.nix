{ ... }:

# DRAFT — not imported; needs btrfs reformat + impermanence input.

{
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/sbctl"           # lanzaboote re-signs from these — must persist
      "/var/lib/systemd"
      "/var/lib/NetworkManager"
      "/var/lib/bluetooth"
      "/var/log"
    ];

    files = [
    ];
  };

  fileSystems."/persist".neededForBoot = true;
}
