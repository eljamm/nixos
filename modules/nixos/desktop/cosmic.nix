{
  config,
  lib,
  inputs,
  ...
}:

let
  cosmicEnabled = config.services.desktopManager.cosmic.enable;
in

{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  # COSMIC Desktop Environment
  services.desktopManager.cosmic.enable = lib.mkDefault false;
  services.displayManager.cosmic-greeter.enable = lib.mkDefault cosmicEnabled;

  nix.settings = lib.mkIf cosmicEnabled {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };
}
