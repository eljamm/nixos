{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-system.url = "github:eljamm/nixpkgs/system";

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
            inputs.musnix.nixosModules.musnix
            inputs.catppuccin.nixosModules.catppuccin
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
                ./hosts/default/gnome
                ./hosts/default/neovim
                ./hosts/default/programs
                ./hosts/default/shell
                ./hosts/default/theme.nix
                ./hosts/default/wezterm
                inputs.catppuccin.homeManagerModules.catppuccin
              ];
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
            ## PopOS Cosmic DE
            {
              nix.settings = {
                substituters = [
                  "https://cosmic.cachix.org/"
                  "https://nix-community.cachix.org"
                  "https://cuda-maintainers.cachix.org"
                  "https://nix-gaming.cachix.org"
                  "https://hyprland.cachix.org"
                  "https://devenv.cachix.org"
                ];
                trusted-public-keys = [
                  "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
                  "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
                  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                  "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
                ];
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
                  hidePodcasts
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
