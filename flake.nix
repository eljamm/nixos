{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-system.url = "github:eljamm/nixpkgs/system";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = [
        # inputs.neovim-nightly-overlay.overlays.default
        inputs.nix-alien.overlays.default
      ];
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./configuration.nix
            inputs.catppuccin.nixosModules.catppuccin
            inputs.musnix.nixosModules.musnix
            inputs.nixos-cosmic.nixosModules.default
            inputs.self.nixosModules.caches
            inputs.self.nixosModules.gnome
            inputs.self.nixosModules.home-manager
            inputs.self.nixosModules.nixIndex
            inputs.self.nixosModules.spicetify
            { nixpkgs.overlays = overlays; }
          ];
        };
      };

      nixosModules = {
        nixIndex = {
          imports = [
            inputs.nix-index-database.nixosModules.nix-index
            ./modules/nixos/nixIndex.nix
          ];
        };
        home-manager = {
          imports = [
            inputs.home-manager.nixosModules.home-manager
            ./modules/nixos/home-manager.nix
          ];
        };
        spicetify = {
          imports = [
            inputs.spicetify-nix.nixosModule
            ./modules/nixos/spicetify.nix
          ];
        };
        gnome = ./modules/nixos/gnome.nix;
        caches = ./modules/nixos/caches.nix;
      };
    };
}