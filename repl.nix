# https://wiki.nixos.org/wiki/Flakes#Getting_Instant_System_Flakes_Repl
let
  flake = builtins.getFlake (toString ./.);
  nixpkgs = import <nixpkgs> { };
in
{ inherit flake; } // flake // builtins // nixpkgs // nixpkgs.lib // flake.nixosConfigurations
