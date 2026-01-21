# /nixos-config/flake.nix
{
  description = "System Flake NixOS configuration";

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
    let
      commonModules = [
        ./configuration.nix
        disko.nixosModules.default
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "hm-backup";
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
    in
    {
      nixosConfigurations.fukurowl-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = commonModules ++ [
          ./hosts/desktop/default.nix
          ./hosts/desktop/disko-config.nix
          ./hosts/desktop/hardware-configuration.nix
        ];
      };

      nixosConfigurations.fukurowl-thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = commonModules ++ [
          ./hosts/thinkpad/default.nix
          ./hosts/thinkpad/disko-config.nix
          ./hosts/thinkpad/hardware-configuration.nix
        ];
      };
    };
}
