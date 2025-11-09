{
  pkgs,
  lib,
  ...
}:
# Cutting-edge mesa (may be unstable)
# NOTE: this also adds stable-mesa to the boot menu
{
  chaotic.mesa-git.enable = true;
  chaotic.mesa-git.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau-va-gl
  ];
}
