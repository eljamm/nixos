{
  self,
  inputs,
  withSystem,
  ...
}:
let
  default = import ../. { inherit inputs; };

  inherit (default)
    devLib
    ;
in
{
  flake = withSystem "x86_64-linux" (
    { devArgs, ... }:
    {
      nixosConfigurations = {
        nixos = devLib.nixosSystem {
          username = "kuroko";
          modules = [
            inputs.agenix.nixosModules.default
            inputs.catppuccin.nixosModules.catppuccin
            inputs.chaotic.nixosModules.default
            self.nixosModules.apps-main
            self.nixosModules.audio
            self.nixosModules.desktops
            self.nixosModules.dev-podman
            self.nixosModules.dev-rust
            self.nixosModules.fonts
            self.nixosModules.home-kuroko
            self.nixosModules.services-common
            self.nixosModules.services-main
            self.nixosModules.virtualisation
            ../hosts/nixos
            ../modules/nixos
          ];
          specialArgs = devArgs;
        };

        navi = devLib.nixosSystem {
          username = "navi";
          modules = [
            inputs.agenix.nixosModules.default
            inputs.catppuccin.nixosModules.catppuccin
            self.nixosModules.dev-podman
            self.nixosModules.home-navi
            self.nixosModules.services-common
            self.nixosModules.services-media
            ../hosts/navi
            ../modules/nixos
          ];
          specialArgs = devArgs;
        };
      };
    }
  );
}
