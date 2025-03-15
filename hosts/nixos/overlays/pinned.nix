{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.27.5";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          tag = "v${version}";
          hash = "sha256-rdBNh9TICeOpglaJ5OJbE/f4W/UPqCkhp8H/H2OBTRM=";
          fetchSubmodules = true;
        };
      };
    })
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./patches/lmstudio.nix { })
  ];
}
