{
  config,
  pkgsUnstable,
  ...
}:
{
  programs.firejail.enable = true;

  programs.adb.enable = true;

  # https://github.com/nix-community/nix-ld
  programs.nix-ld.enable = true;

  # https://github.com/mic92/envfs
  services.envfs.enable = true;

  # Reddit
  services.redlib.enable = true;
  services.redlib.package = pkgsUnstable.redlib.overrideAttrs (oldAttrs: rec {
    version = "0.36.0-unstable-2025-10-06";
    src = pkgsUnstable.fetchFromGitHub {
      owner = "redlib-org";
      repo = "redlib";
      rev = "2dc6b5f3c0db1f8e78a74048ba4550ba6202cb55";
      hash = "sha256-Di3ZZZ4UqR00ud6MdrnJGUngdd/RSC1uNKlsmTdUx2k=";
    };

    cargoDeps = pkgsUnstable.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-VLXRnSICpMOj/4ebhNSwWH9cwAGTz44kQW6Fa02nwIs=";
    };

    checkFlags = oldAttrs.checkFlags ++ [
      "--skip=test_generic_web_backend"
      "--skip=test_mobile_spoof_backend"
    ];
  });

  services.vikunja.enable = true;
  services.vikunja.frontendScheme = "http";
  services.vikunja.frontendHostname = "localhost.vikunja";
}
