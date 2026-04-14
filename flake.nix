{
  description = "scttpr's NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rtk = {
      url = "github:rtk-ai/rtk";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, firefox-addons, rtk, ... }:
  let
    system = "x86_64-linux";
    user = "scttpr";
    pkgs = nixpkgs.legacyPackages.${system};

    rtk-pkg = pkgs.rustPlatform.buildRustPackage {
      pname = "rtk";
      version = "unstable";
      src = rtk;
      cargoLock.lockFile = "${rtk}/Cargo.lock";
      doCheck = false;
    };

    shellConfigs = {

      binanalysis = {
        packages = with pkgs; [
          # disassembler
          radare2

          # debuggers / tracing
          gdb
          gef
          strace
          ltrace

          # binary utilities
          binutils
          elfutils
          patchelf
          file
          hexyl
          xxd

          # forensics / analysis
          binwalk
          yara
          entropy

          # network
          wireshark-cli
        ];
      };

      rust = {
        packages = with pkgs; [
          rustc
          cargo
          rust-analyzer
          clippy
          rustfmt
          cargo-watch
          cargo-edit
        ];

        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      };

      hamradio = {
        packages = with pkgs; [
          # sdr
          sdrpp
          gqrx
          rtl-sdr

          # rf analysis & reverse engineering
          inspectrum
          urh
          rtl_433
          gnuradio

          # digital modes
          wsjtx
          fldigi

          # packet / aprs
          direwolf

          # signal decoding
          multimon-ng

          # satellite
          satdump
          gpredict

          # logging
          adif-multitool
          hamlib

          # radio programming
          chirp
        ];
      };

      netsec = {
        packages = with pkgs; [
          # reconnaissance
          nmap
          masscan

          # dns
          dig
          whois
          dnsenum

          # traffic capture & analysis
          tcpdump
          wireshark-cli
          ngrep

          # traffic manipulation
          mitmproxy
          ettercap

          # packet crafting
          python3Packages.scapy

          # http / web
          curl
          wget
          nikto
          ffuf

          # exploitation
          metasploit
          sqlmap
          hydra
          john
          hashcat

          # wireless
          aircrack-ng

          # smb / snmp enumeration
          enum4linux-ng
          onesixtyone

          # network utilities
          netcat-gnu
          socat
          proxychains-ng
          chisel
          openvpn
          wireguard-tools
          inetutils

          # crypto / tls
          openssl
          testssl
        ];
      };

      llm = {
        packages = with pkgs; [
          ollama-cpu
          aichat
          python3
          uv
        ];
      };

    };

  in
  {
    nixosModules.hardening = import ./modules/hardening.nix;

    nixosConfigurations.p16s = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit user; };
      modules = [
        { nixpkgs.hostPlatform = system; }
        self.nixosModules.hardening
        ./hosts/p16s/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = { inherit firefox-addons rtk-pkg user; };
          home-manager.users.${user} = import ./home;
        }
      ];
    };

    formatter.${system} = pkgs.nixfmt-rfc-style;

    checks.${system}.build = self.nixosConfigurations.p16s.config.system.build.toplevel;

    devShells.${system} = builtins.mapAttrs (name: attrs: pkgs.mkShell (attrs // {
      shellHook = ''echo "${name} shell loaded"'';
    })) shellConfigs;
  };
}
