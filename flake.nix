# /nixos-config/flake.nix
{
  description = "System Flake — NixOS + nix-darwin configurations for Arto's hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:Homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:Homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-omlx = {
      url = "github:jundot/omlx";
      flake = false;
    };
    homebrew-can1357 = {
      url = "github:can1357/homebrew-tap";
      flake = false;
    };
    homebrew-vorssaint = {
      url = "github:vorssaint/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      catppuccin,
      disko,
      home-manager,
      plasma-manager,
      fenix,
      nix-darwin,
      nix-homebrew,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;

      # Auto-import every regular .nix file in `dir`. Used so dropping a new module file
      # into modules/<os>/{nixos,nix-darwin,home} picks it up without touching this file.
      importDir =
        dir:
        map (name: dir + "/${name}") (
          lib.attrNames (
            lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (builtins.readDir dir)
          )
        );

       # Modules shared by every NixOS host.
      nixosCommonModules = (importDir ./modules/linux/nixos) ++ (importDir ./modules/common-system) ++ [
        disko.nixosModules.default
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = { inherit inputs importDir; };
            useGlobalPkgs = true;
            users.artogahr = {
              imports = [
                ./home-linux.nix
                catppuccin.homeModules.catppuccin
                plasma-manager.homeModules.plasma-manager
              ];
            };
          };
        }
      ];

      # Modules shared by every nix-darwin host.
      darwinCommonModules = (importDir ./modules/darwin/nix-darwin) ++ (importDir ./modules/common-system) ++ [
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "artogahr";
            autoMigrate = true;
            mutableTaps = false;
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
              "jundot/homebrew-omlx" = inputs.homebrew-omlx;
              "can1357/homebrew-tap" = inputs.homebrew-can1357;
              "vorssaint/homebrew-tap" = inputs.homebrew-vorssaint;
            };
            trust.taps = [
              "can1357/tap"
              "jundot/omlx"
            ];
          };
          home-manager = {
            extraSpecialArgs = { inherit inputs importDir; };
            useGlobalPkgs = true;
            users.artogahr = {
              imports = [
                ./home-darwin.nix
                catppuccin.homeModules.catppuccin
              ];
            };
          };
        }
      ];
    in
    {
      nixosConfigurations.fukurowl-pc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = nixosCommonModules ++ [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          ./hosts/fukurowl-pc/default.nix
          ./hosts/fukurowl-pc/disko-config.nix
          ./hosts/fukurowl-pc/hardware-configuration.nix
        ];
      };

      nixosConfigurations.fukurowl-thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = nixosCommonModules ++ [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          ./hosts/fukurowl-thinkpad/default.nix
          ./hosts/fukurowl-thinkpad/disko-config.nix
          ./hosts/fukurowl-thinkpad/hardware-configuration.nix
        ];
      };

      darwinConfigurations.fukurowl-macbook = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = darwinCommonModules ++ [
          { nixpkgs.hostPlatform = "aarch64-darwin"; }
          ./hosts/fukurowl-macbook/default.nix
        ];
      };
    };
}
