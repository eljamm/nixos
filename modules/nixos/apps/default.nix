{ ... }:
{
  flake.nixosModules = {
    apps-main =
      { ... }:
      {
        imports = [
          ./gaming
          ./spicetify.nix
          ./video.nix
        ];
      };
  };
}
