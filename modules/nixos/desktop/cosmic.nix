{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.desktops.cosmic;
in
{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  options.desktops.cosmic = {
    enable = lib.mkEnableOption "COSMIC Desktop Environment";
    cache = lib.mkEnableOption "COSMIC Desktop Environment Cache";
  };

  config = lib.mkIf (cfg.enable || cfg.cache) {
    # COSMIC Desktop Environment
    services.desktopManager.cosmic.enable = cfg.enable;
    services.displayManager.cosmic-greeter.enable = cfg.enable;

    nix.settings = lib.mkIf cfg.cache {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };
  };
}
