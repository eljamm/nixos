{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];

  # TODO: finer control over module
  programs.niri = {
    enable = true;
  };
}
