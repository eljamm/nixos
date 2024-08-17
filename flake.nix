{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    nixpkgs-system.url = "github:eljamm/nixpkgs/system";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:eljamm/catppuccin-nix/gtk";

    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";

    blender-bin.url = "github:edolstra/nix-warez?dir=blender";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = [
        inputs.fenix.overlays.default
        inputs.nix-alien.overlays.default
        (final: prev: {
          # TODO: update
          custom = import inputs.nixpkgs-system {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./configuration.nix
            ./modules/nixos/home-manager.nix
            inputs.agenix.nixosModules.default
            inputs.catppuccin.nixosModules.catppuccin
            inputs.lix-module.nixosModules.default
            inputs.self.nixosModules.default
            { nixpkgs.overlays = overlays; }
          ];
        };
      };

      homeConfigurations.kuroko = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ../../hosts/default/home.nix ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };

      nixosModules = {
        default = ./modules/nixos;
      };
    };
}
