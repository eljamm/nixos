{
  flake.nixosModules.nvidia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      VK_DRIVER_FILES = lib.concatStringsSep ":" [
        "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.x86_64.json"
        "${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd.i686.json"
      ];

      # Script to offload graphics rendering to dedicated GPU
      nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        # Offload graphics rendering to dedicated GPU (Nvidia)
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        export VK_DRIVER_FILES="${VK_DRIVER_FILES}"
        exec "$@"
      '';
    in
    {
      environment.systemPackages = [
        nvidia-offload
        pkgs.nvitop
      ];

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];

      boot.kernelParams = [
        # "nvidia.NVreg_UsePageAttributeTable=1" # improve performance with PAT
      ];

      boot.blacklistedKernelModules = [ "nouveau" ];
      boot.extraModprobeConfig =
        # Blacklist nouveau
        ''
          blacklist nouveau
          options nouveau modeset=0
        ''
        # Supposedly fixes suspend with Nvidia
        # https://discourse.nixos.org/t/psa-for-those-with-hibernation-issues-on-nvidia
        + ''
          options nvidia_modeset vblank_sem_control=0
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
          reverseSync.enable = true;
          # sync.enable = true;

          # Enable if using an external GPU
          allowExternalGpu = false;

          amdgpuBusId = "PCI:52:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };

        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "575.64.05";
          sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
          sha256_aarch64 = "sha256-GRE9VEEosbY7TL4HPFoyo0Ac5jgBHsZg9sBKJ4BLhsA=";
          openSha256 = "sha256-mcbMVEyRxNyRrohgwWNylu45vIqF+flKHnmt47R//KU=";
          settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
          persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";
        };
      };

      environment.variables = {
        # Use integrated GPU for gnome-shell
        # See https://gitlab.gnome.org/GNOME/mutter/-/issues/2969
        # __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json";
        # __GLX_VENDOR_LIBRARY_NAME = "mesa";
        # VK_DRIVER_FILES = "${lib.concatStringsSep ":" [
        #   "${pkgs.mesa}/share/vulkan/icd.d/radeon_icd.x86_64.json"
        #   "${pkgs.mesa_i686}/share/vulkan/icd.d/radeon_icd.i686.json"
        # ]}";
      };
    };
}
