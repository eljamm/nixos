# https://wiki.nixos.org/wiki/Flakes#Getting_Instant_System_Flakes_Repl
{
  default ? import ./. { },
  flake ? default.self,
  inputs ? flake.inputs,
  ...
}:
{
  inherit flake;
}
// flake
// builtins
// inputs.nixpkgs
// inputs.nixpkgs.lib
// flake.nixosConfigurations
