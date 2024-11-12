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
    };
  };

  environment.variables = {
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
}
