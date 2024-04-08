{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    envfs = {
      url = "github:Mic92/envfs";
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
  };

  outputs = { self, nixpkgs, ... } @inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            {
              nixpkgs.overlays = overlays;
            }
            ## system
            ./configuration.nix
            inputs.self.nixosModules.gnome
            inputs.envfs.nixosModules.envfs
            self.nixosModules.nixIndex
            ## Home Manager
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kuroko.imports = [
                ./hosts/default/home.nix
              ];
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
            ## PopOS Cosmic DE
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            inputs.nixos-cosmic.nixosModules.default
            inputs.spicetify-nix.nixosModule
            {
              programs.spicetify = {
                enable = true;
                theme = inputs.spicetify-nix.packages.${pkgs.system}.default.themes.catppuccin;
                colorScheme = "macchiato";

                enabledExtensions = with inputs.spicetify-nix.packages.${pkgs.system}.default.extensions; [
                  adblock
                  autoSkipVideo
                  bookmark
                  fullAppDisplay
                  keyboardShortcut
                  loopyLoop
                  popupLyrics
                  shuffle # shuffle+ (special characters are sanitized out of ext names)
                ];
              };
            }
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
        gnome = ./modules/nixos/gnome.nix;
      };

    };
}
