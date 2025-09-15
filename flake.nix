# /nixos-config/flake.nix
{
  description = "System Flake NixOS configuration";

  inputs = {
    # NixOS official package repository, tracking the unstable branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Disko for declarative disk partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";

    # Home Manager for declarative user-environment management
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Plasma Manager for declarative KDE Plasma configuration
    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    # Rust development stuff
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    # Tidal client
    tidaLuna.url = "github:Inrixia/TidaLuna";
  };

  outputs =
    {
      self,
      nixpkgs,
      catppuccin,
      disko,
      home-manager,
      plasma-manager,
      tidaLuna,
      fenix,
      ...
    }@inputs:
    {
      nixosConfigurations.fukurowl-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass flake inputs to our modules
        modules = [
          ./disko-config.nix
          ./configuration.nix
          ./hardware-configuration.nix

          disko.nixosModules.default
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager

          {
            home-manager = {
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
              useGlobalPkgs = true;
              users.arto = {
                imports = [
                  ./home.nix
                  catppuccin.homeModules.catppuccin
                  plasma-manager.homeModules.plasma-manager
                ];
              };
            };
          }
        ];
      };
    };
}
