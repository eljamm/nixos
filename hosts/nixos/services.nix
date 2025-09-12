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
  services.redlib.package = pkgsUnstable.redlib.overrideAttrs rec {
    version = "0.36.0-unstable-2025-09-09";
    src = pkgsUnstable.fetchFromGitHub {
      owner = "redlib-org";
      repo = "redlib";
      rev = "a989d19ca92713878e9a20dead4252f266dc4936";
      hash = "sha256-YJZVkCi8JQ1U47s52iOSyyf32S3b35pEqw4YTW8FHVY=";
    };

    cargoDeps = pkgsUnstable.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-L35VSQdIbKGGsBPU2Sj/MoYohy1ZibgZ+7NVa3yNjH8=";
    };
  };

  services.vikunja.enable = true;
  services.vikunja.frontendScheme = "http";
  services.vikunja.frontendHostname = "localhost.vikunja";
}
