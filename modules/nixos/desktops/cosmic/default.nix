{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.custom.desktops.cosmic;
in
{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  options.custom.desktops.cosmic = {
    cache = lib.mkEnableOption "the COSMIC desktop environment cache";
    enable = lib.mkEnableOption "the COSMIC desktop environment";
    enableGreeter = lib.mkEnableOption "the COSMIC login manager";
  };

  config = lib.mkIf (cfg.enable || cfg.cache) {
    custom.desktops.cosmic.enableGreeter = lib.mkDefault cfg.enable;

    # COSMIC Desktop Environment
    services.desktopManager.cosmic.enable = cfg.enable;
    services.displayManager.cosmic-greeter.enable = cfg.enableGreeter;

    nix.settings = lib.mkIf cfg.cache {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };
  };
}
