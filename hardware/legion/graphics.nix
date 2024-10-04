{
  config,
  pkgs,
  lib,
  ...
}:
let
  amd-offload = pkgs.writeShellScriptBin "amd-offload" ''
    export __EGL_VENDOR_LIBRARY_FILENAMES="${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json"
    export __GLX_VENDOR_LIBRARY_NAME="mesa"
    export VK_DRIVER_FILES="${
      lib.concatStringsSep ":" [
        "${pkgs.mesa.drivers}/share/vulkan/icd.d/radeon_icd.x86_64.json"
        "${pkgs.mesa_i686.drivers}/share/vulkan/icd.d/radeon_icd.i686.json"
      ]
    }"
    export DRI_PRIME=0
    exec "$@"
  '';
in
{
  # NOTE: adds stable-mesa to the boot menu
  # WIP: has problems with amdgpu
  # chaotic.mesa-git.enable = true;

  hardware.amdgpu.initrd.enable = false;

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
