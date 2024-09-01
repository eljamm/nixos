{
  inputs,
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
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = [ amd-offload ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };
}
