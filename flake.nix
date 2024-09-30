{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-system.url = "github:eljamm/nixpkgs/system";

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

    niri = {
      url = "github:sodiboo/niri-flake";
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

    catppuccin.url = "github:catppuccin/nix";

    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";

    blender-bin.url = "github:edolstra/nix-warez?dir=blender";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = [
        inputs.nix-alien.overlays.default
      ];
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            pkgsCustom = inputs.nixpkgs-system.legacyPackages.${system};
            inherit self inputs;
          };
          modules = [
            ./hosts/nixos
            ./modules/nixos
            # ./specialisation.nix
            inputs.agenix.nixosModules.default
            inputs.catppuccin.nixosModules.catppuccin
            inputs.chaotic.nixosModules.default
            { nixpkgs.overlays = overlays; }
          ];
        };
      };

      homeConfigurations.kuroko = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./hosts/nixos/users/kuroko/home/default.nix ];
        extraSpecialArgs = {
          pkgsCustom = inputs.nixpkgs-system.legacyPackages.${system};
          inherit inputs;
        };
      };
    };
}
