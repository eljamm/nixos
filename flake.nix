{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:eljamm/nixpkgs/system";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    blender-bin.url = "github:edolstra/nix-warez?dir=blender";
    nix-alien.url = "github:thiagokokada/nix-alien";

    # https://github.com/NixOS/nixpkgs/pull/295587
    nixpkgs-yuzu.url = "github:nixos/nixpkgs/f20a0c955555fb68cfc72886d7476de2aacd1b4e";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      # See ./flake/*.nix for the modules that are imported here.
      imports = with builtins; map (fn: ./flake/${fn}) (attrNames (readDir ./flake));
    };
}
