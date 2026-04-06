{ pkgs, ... }:

{
  # ── Network ──
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.macAddress = "stable";
      ethernet.macAddress = "stable";
      settings.connection."ipv6.ip6-privacy" = 2;
      dispatcherScripts = [{
        # Disable wifi when ethernet connects, re-enable when it disconnects
        type = "basic";
        source = pkgs.writeText "wifi-toggle" ''
          IFACE=$1
          ACTION=$2
          case "$IFACE" in
            e*)
              case "$ACTION" in
                up)   nmcli radio wifi off ;;
                down) nmcli radio wifi on ;;
              esac
              ;;
          esac
        '';
      }];
    };
    firewall = {
      enable = true;
      logRefusedConnections = true;
    };
  };

  # ── VPN (ProtonVPN via WireGuard) ──
  # Start/stop manually: sudo systemctl start/stop wg-quick-protonvpn
  networking.wg-quick.interfaces.protonvpn = {
    autostart = false;
    address = [ "<INTERFACE_ADDRESS>" ];
    dns = [ "<INTERFACE_DNS>" ];
    privateKeyFile = "/etc/wireguard/protonvpn-key";

    peers = [{
      publicKey = "<PEER_PUBLIC_KEY>";
      endpoint = "<PEER_ENDPOINT>";
      allowedIPs = [ "0.0.0.0/0" "::/0" ];
      persistentKeepalive = 25;
    }];
  };

  # ── Encrypted DNS ──
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
      ];
      FallbackDNS = [
        "1.1.1.1#cloudflare-dns.com"
      ];
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
    };
  };
}
