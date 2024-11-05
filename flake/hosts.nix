{
  inputs,
  self,
  withSystem,
  ...
}:
{
  flake = withSystem "x86_64-linux" (
    ctx@{ inputs', ... }:
    {
      nixosConfigurations = {
        nixos = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self inputs inputs';
            pkgsCustom = inputs'.nixpkgs-stable.legacyPackages;
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

      homeConfigurations.kuroko = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs'.nixpkgs.legacyPackages;
        modules = [ ../hosts/nixos/users/kuroko/home/default.nix ];
        extraSpecialArgs = {
          inherit self inputs inputs';
          pkgsCustom = inputs'.nixpkgs-stable.legacyPackages;
        };
      };
    }
  );
}
