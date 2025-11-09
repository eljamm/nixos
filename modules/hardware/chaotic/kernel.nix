{
  lib,
  pkgs,
  ...
}:
# linux-cachyos kernel with `sched_ext`
{
  # The patches will probably be merged into linux 6.12.
  # Could be fun to play around with until then.
  # ---
  # https://github.com/sched-ext/scx
  # https://github.com/chaotic-cx/nyx?tab=readme-ov-file#using-linux-cachyos-with-sched-ext
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  chaotic.scx.enable = true; # by default uses scx_rustland scheduler
}
