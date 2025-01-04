{
  lib,
  inputs,
  ...
}:
{
  nixosSystem =
    {
      username,
      modules,
      specialArgs,
      ...
    }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = specialArgs // {
        inherit username;
      };
      inherit modules;
    };
}
