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

    shellConfigs = import ./shells.nix { inherit pkgs; };

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
