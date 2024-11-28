{ ... }:
{
  programs.firejail.enable = true;

  programs.adb.enable = true;

  # https://github.com/nix-community/nix-ld
  programs.nix-ld.enable = true;

  # https://github.com/mic92/envfs
  services.envfs.enable = true;

  # Reddit
  services.redlib.enable = true;
}
