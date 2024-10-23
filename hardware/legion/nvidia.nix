{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Check if proprietary Nvidia drivers are enabled
  nvidiaEnabled = lib.elem "nvidia" config.services.xserver.videoDrivers;

  VK_DRIVER_FILES = lib.concatStringsSep ":" (
    if nvidiaEnabled then
      [
        "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.x86_64.json"
        "${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd.i686.json"
      ]
    else
      [
        "${pkgs.mesa.drivers}/share/vulkan/icd.d/nouveau_icd.x86_64.json"
        "${pkgs.mesa_i686.drivers}/share/vulkan/icd.d/nouveau_icd.i686.json"
      ]
  );

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
        export VK_DRIVER_FILES="${VK_DRIVER_FILES}"
        exec "$@"
      ''
    else
      # sh
      ''
        # Offload graphics rendering to dedicated GPU (Nouveau)
        export __EGL_VENDOR_LIBRARY_FILENAMES="${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json"
        export __GLX_VENDOR_LIBRARY_NAME=mesa
        export VK_DRIVER_FILES="${VK_DRIVER_FILES}"
        export DRI_PRIME=1
        exec "$@"
      ''
  );
in
{
  boot.kernelParams = lib.mkIf (!nvidiaEnabled) [
    # Fix Wayland flickering & AMD-Vi IO_PAGE_FAULT errors with Nouveau
    # https://gitlab.freedesktop.org/drm/nouveau/-/issues/225
    "iommu=pt"

    # Enable power management
    # https://nouveau.freedesktop.org/PowerManagement.html
    "nouveau.config=NvGspRm=1"
  ];

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
        services.xserver.videoDrivers = [ "nvidia" ];

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
            version = "565.57.01"; # beta
            sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
            sha256_aarch64 = "sha256-aDVc3sNTG4O3y+vKW87mw+i9AqXCY29GVqEIUlsvYfE=";
            openSha256 = "sha256-/tM3n9huz1MTE6KKtTCBglBMBGGL/GOHi5ZSUag4zXA=";
            settingsSha256 = "sha256-H7uEe34LdmUFcMcS6bz7sbpYhg9zPCb/5AmZZFTx1QA=";
            persistencedSha256 = "sha256-hdszsACWNqkCh8G4VBNitDT85gk9gJe1BlQ8LdrYIkg=";
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

        environment.variables = {
          # GBM_BACKEND = "nvidia-drm";
          # WLR_NO_HARDWARE_CURSORS = "1";
          # __EGL_VENDOR_LIBRARY_FILENAMES = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
          # __GLX_VENDOR_LIBRARY_NAME = "nvidia";

          # Use integrated GPU for gnome-shell
          # See https://gitlab.gnome.org/GNOME/mutter/-/issues/2969
          __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json";
          __GLX_VENDOR_LIBRARY_NAME = "mesa";
          # VK_DRIVER_FILES = "${lib.concatStringsSep ":" [
          #   "${pkgs.mesa.drivers}/share/vulkan/icd.d/radeon_icd.x86_64.json"
          #   "${pkgs.mesa_i686.drivers}/share/vulkan/icd.d/radeon_icd.i686.json"
          # ]}";
        };

        # CUDA cache
        nix.settings = {
          substituters = [ "https://cuda-maintainers.cachix.org" ];
          trusted-public-keys = [
            "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
          ];
        };
      };
    };
  };
}
