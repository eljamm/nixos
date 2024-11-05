{ self, inputs, ... }:
let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
{
  flake.nixosConfigurations = {
    nixos = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self inputs;
        pkgsCustom = inputs.nixpkgs-stable.legacyPackages.${system};
      };
      modules = [
        ../hosts/nixos
        ../modules/nixos
        inputs.agenix.nixosModules.default
        inputs.catppuccin.nixosModules.catppuccin
        inputs.chaotic.nixosModules.default
        {
          # TODO: is nix-alien needed?
          nixpkgs.overlays = [ inputs.nix-alien.overlays.default ];
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };
  };

  flake.homeConfigurations.kuroko = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ ../hosts/nixos/users/kuroko/home/default.nix ];
    extraSpecialArgs = {
      inherit inputs;
      pkgsCustom = inputs.nixpkgs-stable.legacyPackages.${system};
    };
  };
}
