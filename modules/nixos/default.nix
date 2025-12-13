{ lib, ... }:
{
  imports = [
    ./audio
    ./services
    ./settings.nix
    ./system
    ./tools
  ];

  # go wild
  options.debug = lib.mkOption {
    type = with lib.types; attrsOf anything;
    default = { };
  };
}
