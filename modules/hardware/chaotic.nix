{ inputs, ... }:
{
  flake.nixosModules = {
    # linux-cachyos kernel with `sched_ext`
    chaoticKernel =
      { pkgs, lib, ... }:
      {
        # The patches will probably be merged into linux 6.12.
        # Could be fun to play around with until then.
        # ---
        # https://github.com/sched-ext/scx
        # https://github.com/chaotic-cx/nyx?tab=readme-ov-file#using-linux-cachyos-with-sched-ext
        boot.kernelPackages = pkgs.linuxPackages_cachyos;
        chaotic.scx.enable = true; # by default uses scx_rustland scheduler
      };

    # Cutting-edge mesa (may be unstable)
    # NOTE: this also adds stable-mesa to the boot menu
    chaoticMesa =
      { pkgs, lib, ... }:
      {
        chaotic.mesa-git.enable = true;
        chaotic.mesa-git.extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
  };
}
