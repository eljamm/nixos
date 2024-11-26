{
  inputs,
  self,
  withSystem,
  ...
}:
{
  flake = withSystem "x86_64-linux" (
    ctx@{ inputs', ... }:
    let
      args = {
        inherit self inputs inputs';
        pkgsCustom = inputs'.nixpkgs-stable-system.legacyPackages;
      };
    in
    {
      nixosConfigurations = {
        nixos = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = args;
          modules = [
            ../hosts/nixos
            ../modules/nixos
            inputs.agenix.nixosModules.default
            inputs.catppuccin.nixosModules.catppuccin
            inputs.chaotic.nixosModules.default
            self.nixosModules.home-kuroko
            self.nixosModules.desktops
          ];
        };
      };
    }
  );
}
