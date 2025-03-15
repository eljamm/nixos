{
  flake.nixosModules.nouveau =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # Check if proprietary Nvidia drivers are enabled
      nvidiaEnabled = lib.elem "nvidia" config.services.xserver.videoDrivers;

      VK_DRIVER_FILES = lib.concatStringsSep ":" [
        "${pkgs.mesa.drivers}/share/vulkan/icd.d/nouveau_icd.x86_64.json"
        "${pkgs.mesa_i686.drivers}/share/vulkan/icd.d/nouveau_icd.i686.json"
      ];

      # Script to offload graphics rendering to dedicated GPU
      nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        # Offload graphics rendering to dedicated GPU (Nouveau)
        export __EGL_VENDOR_LIBRARY_FILENAMES="${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json"
        export __GLX_VENDOR_LIBRARY_NAME=mesa
        export VK_DRIVER_FILES="${VK_DRIVER_FILES}"
        export DRI_PRIME=1
        exec "$@"
      '';
    in
    {
      config = lib.mkIf (!nvidiaEnabled) {
        boot.kernelParams = [
          # Fix Wayland flickering & AMD-Vi IO_PAGE_FAULT errors with Nouveau
          # https://gitlab.freedesktop.org/drm/nouveau/-/issues/225
          "iommu=pt"

          # Enable power management
          # https://nouveau.freedesktop.org/PowerManagement.html
          "nouveau.config=NvGspRm=1"
        ];

        environment.systemPackages = [
          nvidia-offload
        ];
      };
    };
}
