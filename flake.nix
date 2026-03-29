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
    pkgs = nixpkgs.legacyPackages.${system};

    rtk-pkg = pkgs.rustPlatform.buildRustPackage {
      pname = "rtk";
      version = "unstable";
      src = rtk;
      cargoLock.lockFile = "${rtk}/Cargo.lock";
      doCheck = false;
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/nixos/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = { inherit firefox-addons rtk-pkg; };
          home-manager.users.scttpr = import ./home;
        }
      ];
    };

    devShells.${system} = builtins.mapAttrs (name: attrs: pkgs.mkShell (attrs // {
      shellHook = ''echo "${name} shell loaded"'';
    })) {

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
          rtl-sdr

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

      llm = {
        packages = with pkgs; [
          ollama-cpu
          aichat
          python3
          uv
        ];
      };

    };
  };
}
