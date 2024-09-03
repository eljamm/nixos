{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  amd-offload = pkgs.writeShellScriptBin "amd-offload" ''
    export __EGL_VENDOR_LIBRARY_FILENAMES="${pkgs.mesa.drivers.outPath}/share/glvnd/egl_vendor.d/50_mesa.json"
    export __GLX_VENDOR_LIBRARY_NAME="mesa"
    export VK_DRIVER_FILES="${pkgs.mesa.drivers.outPath}/share/vulkan/icd.d/radeon_icd.x86_64.json"
    exec "$@"
  '';
in
{
  # NOTE: adds stable-mesa to the boot menu
  # WIP: has problems with amdgpu
  # chaotic.mesa-git.enable = true;

  # Load amdgpu driver for Xorg and Wayland
  # NOTE: probably useless to do, but oh well
  services.xserver.videoDrivers = lib.mkBefore [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  environment.systemPackages = [
    amd-offload
    pkgs.lact
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
}
