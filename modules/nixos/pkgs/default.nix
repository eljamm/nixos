{ pkgs, ... }:
with pkgs;
{
  nixpkgs.overlays = [
    (final: prev: { cinny-desktop = callPackage ./ci/cinny-desktop/package.nix { }; })
    # FIX: wait for next release
    (final: prev: { redlib = callPackage ./re/redlib/package.nix { }; })
    (final: prev: {
      kitty = callPackage ./ki/kitty/package.nix {
        buildGoModule = pkgs.buildGo123Module;
        go = go_1_23;
      };
    })
    (final: prev: { vocabsieve = callPackage ./vo/vocabsieve/package.nix { }; })

    # pgsrip
    (final: prev: { cleanit = callPackage ./cl/cleanit/package.nix { }; })
    (final: prev: { pgsrip = callPackage ./pg/pgsrip/package.nix { }; })
    (final: prev: { trakit = callPackage ./tr/trakit/package.nix { }; })
  ];

  environment.systemPackages = with pkgs; [
    pgsrip
    vocabsieve
  ];
}
