{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Check if proprietary Nvidia drivers are enabled
  nvidiaEnabled = lib.elem "nvidia" config.services.xserver.videoDrivers;

  # Script to offload graphics rendering to dedicated GPU
  # TODO: refactor
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" (
    if nvidiaEnabled then
      # sh
      ''
        # Offload graphics rendering to dedicated GPU (Nvidia)
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        export VK_DRIVER_FILES="${
          lib.concatStringsSep ":" [
            "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.x86_64.json"
            "${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd.i686.json"
          ]
        }"
        exec "$@"
      ''
    else
      # sh
      ''
        # Offload graphics rendering to dedicated GPU (Nouveau)
        export __EGL_VENDOR_LIBRARY_FILENAMES="${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json"
        export __GLX_VENDOR_LIBRARY_NAME=mesa
        export VK_DRIVER_FILES="${
          lib.concatStringsSep ":" [
            "${pkgs.mesa.drivers}/share/vulkan/icd.d/nouveau_icd.x86_64.json"
            "${pkgs.mesa_i686.drivers}/share/vulkan/icd.d/nouveau_icd.i686.json"
          ]
        }"
        export DRI_PRIME=1
        exec "$@"
      ''
  );
in
{
  boot.kernelParams = [
    # Fix Wayland flickering & AMD-Vi IO_PAGE_FAULT errors with Nouveau
    # https://gitlab.freedesktop.org/drm/nouveau/-/issues/225
    "iommu=pt"

    # Enable power management
    # https://nouveau.freedesktop.org/PowerManagement.html
    "nouveau.config=NvGspRm=1"
  ];

  services.xserver.videoDrivers = lib.mkBefore [ "nouveau" ];

  environment.systemPackages = [
    nvidia-offload
  ] ++ lib.optionals nvidiaEnabled [ pkgs.nvitop ];

  # Additional boot menu selection for running the proprietary Nvidia drivers
  # NOTE: X11 feels smoother than Wayland, at least under Gnome
  specialisation = {
    nvidia-closed = {
      configuration = {
        system.nixos.tags = [ "nvidia-closed" ];
        environment.etc."specialisation".text = "nvidia-closed"; # hint for nh

        # Load nvidia driver for Xorg and Wayland
        services.xserver.videoDrivers = lib.mkBefore [ "nvidia" ];

        boot.kernelParams = [
          "nvidia.NVreg_UsePageAttributeTable=1" # improve performance with PAT
        ];

        # Blacklist nouveau
        boot.blacklistedKernelModules = [ "nouveau" ];
        boot.extraModprobeConfig = ''
          blacklist nouveau
          options nouveau modeset=0
        '';

        hardware.nvidia = {
          # Modesetting is required.
          modesetting.enable = true;

          # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
          # Enable this if you have graphical corruption issues or application crashes after waking
          # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
          # of just the bare essentials.
          powerManagement.enable = true;

          # Fine-grained power management. Turns off GPU when not in use.
          # Experimental and only works on modern Nvidia GPUs (Turing or newer).
          # powerManagement.finegrained = true;
          powerManagement.finegrained = true;

          # Use the NVidia open source kernel module (not to be confused with the
          # independent third-party "nouveau" open source driver).
          # Support is limited to the Turing and later architectures. Full list of 
          # supported GPUs is at: 
          # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
          # Only available from driver 515.43.04+
          # NOTE: Enabled by default from driver 560.28.03+
          open = true;

          # Enable the Nvidia settings menu,
          # accessible via `nvidia-settings`.
          nvidiaSettings = true;

          prime = {
            offload.enable = true;
            # reverseSync.enable = true;
            # sync.enable = true;

            # Enable if using an external GPU
            allowExternalGpu = false;

            amdgpuBusId = "PCI:52:0:0";
            nvidiaBusId = "PCI:1:0:0";
          };

          package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
            version = "560.35.03"; # stable
            sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
            sha256_aarch64 = "sha256-s8ZAVKvRNXpjxRYqM3E5oss5FdqW+tv1qQC2pDjfG+s=";
            openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
            settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
            persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";
            # Lower Nvidia icd priority so gnome-shell uses the iGPU instead of the dGPU,
            # thus improving the smoothness of the system.
            # See: https://gitlab.gnome.org/GNOME/mutter/-/issues/2969
            postInstall = ''
              for i in $lib32 $out; do
                if [ "$useGLVND" = "1" ]; then
                  mv "$i/share/glvnd/egl_vendor.d/10_nvidia.json" "$i/share/glvnd/egl_vendor.d/90_nvidia.json"
                fi
              done
            '';
          };
        };
      };
    };
  };

}
