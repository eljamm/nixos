{
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.ncro.nixosModules.default
  ];

  services.ncro = {
    enable = true;
    settings = {
      server = {
        listen = ":8888";
      };
      upstreams = [
        {
          url = "https://cache.nixos.org";
          priority = 10;
          public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        }

        {
          url = "https://nix-community.cachix.org";
          priority = 20;
          public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
        }
      ];
      logging.timestamps = false;
    };
  };

  # Point Nix at the proxy. By default the module appends every configured
  # upstream public_key/public_keys, plus the fallback_cache public keys when
  # fallback is enabled, to nix.settings.trusted-public-keys; set
  # services.ncro.addUpstreamPublicKeys = false to manage those keys yourself.
  #
  # NOTE: ncro needs to be the *only* substituter if you wish to benefit
  # from its capabilities fully. If there are other substituters in your
  # list, or if you don't mkForce this option, ncro will perform less
  # efficiently.
  nix.settings.substituters = lib.mkForce [ "http://localhost:8888" ];
}
