{
  lib,
  pkgs,
  inputs,
  ...
}@args:
let
  treefmt-nix = import inputs.treefmt-nix;

  treefmt-cfg = {
    projectRootFile = "default.nix";
    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
    programs.zizmor.enable = true;
  };
  treefmt = treefmt-nix.mkWrapper pkgs treefmt-cfg;
  treefmt-pkgs = (treefmt-nix.evalModule pkgs treefmt-cfg).config.build.devShell.nativeBuildInputs;
in
{
  formatter = treefmt;
  formatter-pkgs = treefmt-pkgs;
}
