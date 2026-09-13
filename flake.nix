{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
    nixpkgs-unstable.url = "https://channels.nixos.org/nixos-unstable-small/nixexprs.tar.zst";
    nixpkgs-custom = {
      url = "github:eljamm/nixpkgs-custom";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    ncro = {
      url = "github:manic-systems/ncro";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/v26.05";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    gowt = {
      url = "github:eljamm/gowt/dev";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
  };

  # import flake attributes from ./default.nix
  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib)
        eachSystem
        eachSystemPassThrough
        ;

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      getDefault = system: (import ./. { inherit self inputs system; });
      importFlake = arg: system: (getDefault system).flake.${arg} or { };

      # independant of system (e.g. nixosModules)
      systemAgnosticFlake = eachSystemPassThrough systems (importFlake "systemAgnostic");

      # depends on system (e.g. packages.x86_64-linux)
      perSystemFlake = eachSystem systems (importFlake "perSystem");
    in
    systemAgnosticFlake // perSystemFlake;
}
