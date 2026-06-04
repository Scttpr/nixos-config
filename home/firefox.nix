{ pkgs, firefox-addons, ... }:

{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;

      HttpsOnlyMode = "force_enabled";
      DNSOverHTTPS = {
        Enabled = false;
        Locked = true;
      };
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = true;
      };
      PopupBlocking.Default = true;
      SanitizeOnShutdown = {
        Cache = true;
        FormData = true;
        Downloads = true;
      };

      DisableFormHistory = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
    };

    profiles.default = {
      isDefault = true;

      containers = {
        personal = { id = 1; color = "blue"; icon = "fingerprint"; };
        pdi      = { id = 2; color = "orange"; icon = "briefcase"; };
        banking  = { id = 3; color = "green"; icon = "dollar"; };
        shopping = { id = 4; color = "pink"; icon = "cart"; };
        social   = { id = 5; color = "purple"; icon = "fence"; };
        radio    = { id = 6; color = "turquoise"; icon = "circle"; };
      };
      containersForce = true;

      search = {
        default = "google";
        privateDefault = "ddg";
        force = true;
        engines = {
          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages?query={searchTerms}"; }];
            definedAliases = [ "@np" ];
          };
          "NixOS Options" = {
            urls = [{ template = "https://search.nixos.org/options?query={searchTerms}"; }];
            definedAliases = [ "@no" ];
          };
          "bing".metaData.hidden = true;
        };
      };

      extensions.packages = with firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        skip-redirect
        clearurls
        localcdn
        proton-pass
        multi-account-containers
      ];

      settings = {
        # no_host=false: relay-only forcing causes lag/freezes in Google Meet
        "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.ice.no_host" = false;

        # must set false explicitly: stale prefs.js values break canvas/WebGL and SSO
        "privacy.resistFingerprinting" = false;
        "privacy.firstparty.isolate" = false;

        "network.http.speculative-parallel-limit" = 0;
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "network.predictor.enabled" = false;

        "media.autoplay.default" = 5;

        "security.tls.version.min" = 3;
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = true;

        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;

        "geo.enabled" = false;

        # webrender.compositor blocklisted by gfxInfo for radeonsi — leave default
        "gfx.webrender.all" = true;
        "widget.dmabuf.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;

        "browser.newtabpage.enabled" = false;

      };
    };
  };
}
