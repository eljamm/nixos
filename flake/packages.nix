{
  perSystem =
    {
      devArgs,
      pkgs,
      ...
    }:
    {
      packages = {
        lmstudio = pkgs.callPackage ../hosts/nixos/overlays/patches/lmstudio.nix { };

        inherit (devArgs.pkgsUnstable) whisper-ctranslate2;
      };
    };
}
