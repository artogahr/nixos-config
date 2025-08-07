# /nixos-config/flake.nix
{
  description = "System Flake NixOS configuration";

  inputs = {
    # NixOS official package repository, tracking the unstable branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Disko for declarative disk partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager for declarative user-environment management
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, home-manager, ... }@inputs: {
    nixosConfigurations.fukurowl-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # Pass flake inputs to our modules
      modules = [
        # The declarative disk configuration
        ./disko-config.nix

        # The main system configuration
        ./configuration.nix

        # The generated hardware configuration
        ./hardware-configuration.nix

        # Import Disko's NixOS module to enable it
        disko.nixosModules.default

        # Import Home Manager's NixOS module to enable it
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
