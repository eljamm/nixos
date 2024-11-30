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
      args =
        {
          username ? "",
        }:
        {
          inherit
            self
            inputs
            inputs'
            username
            ;
          pkgsCustom = inputs'.nixpkgs-stable-system.legacyPackages;
        };
    in
    {
      nixosConfigurations = {
        nixos = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = args { username = "kuroko"; };
          modules = [
            inputs.agenix.nixosModules.default
            inputs.catppuccin.nixosModules.catppuccin
            inputs.chaotic.nixosModules.default
            self.nixosModules.apps-main
            self.nixosModules.audio
            self.nixosModules.desktops
            self.nixosModules.dev-rust
            self.nixosModules.fonts
            self.nixosModules.home-kuroko
            self.nixosModules.services-common
            self.nixosModules.services-main
            self.nixosModules.virtualisation
            ../hosts/nixos
            ../modules/nixos
          ];
        };
          ];
        };
      };
    }
  );
}
