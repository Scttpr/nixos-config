{ pkgs, firefox-addons, ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      # Disable telemetry
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;

      # Security
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

      # Disable risky features
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
        default = "ddg";
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

      extensions.packages = with firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        skip-redirect
        clearurls
        localcdn
        proton-pass
        multi-account-containers
      ];

      settings = {
        # WebRTC: restrict to default interface only (prevents local IP enumeration
        # while still allowing direct peer connections — no_host is omitted because
        # it forces relay-only, causing lag/freezes in Google Meet)
        "media.peerconnection.ice.default_address_only" = true;

        # Disable speculative connections
        "network.http.speculative-parallel-limit" = 0;
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "network.predictor.enabled" = false;

        # Block autoplay
        "media.autoplay.default" = 5;

        # TLS hardening — require TLS 1.2+, enable OCSP
        "security.tls.version.min" = 3;
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = true;

        # Disable search suggestions (leaks keystrokes to search engine)
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;

        # Disable location
        "geo.enabled" = false;

        # DRM (needed for Netflix, Spotify, etc.)
        "media.eme.enabled" = true;

        # Wayland rendering — reduce flickering
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;

        # Disable new tab clutter
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # Disable telemetry
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # HTTPS-only
        "dom.security.https_only_mode" = true;

        # Anti-fingerprinting
        "privacy.resistFingerprinting" = true;

      };
    };
  };
}
