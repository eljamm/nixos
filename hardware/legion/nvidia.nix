{
  config,
  lib,
  pkgs,
  ...
}:
let
  vulkanDriverFiles = [
    "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.x86_64.json"
    "${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd.i686.json"
  ];
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    export VK_DRIVER_FILES="${builtins.concatStringsSep ":" vulkanDriverFiles}"
    export DRI_PRIME = "pci-0000_01_00_0";
    exec "$@"
  '';
  amd-offload = pkgs.writeShellScriptBin "amd-offload" ''
    export __EGL_VENDOR_LIBRARY_FILENAMES="${pkgs.mesa.drivers.outPath}/share/glvnd/egl_vendor.d/50_mesa.json"
    export __GLX_VENDOR_LIBRARY_NAME="mesa"
    export VK_DRIVER_FILES="${pkgs.mesa.drivers.outPath}/share/vulkan/icd.d/radeon_icd.x86_64.json"
    exec "$@"
  '';
in
{
  # NOTE: Nvidia has a lot of problems with Wayland, so use X11 for now (unless you like pain).

  # FIX:
  # boot.kernelParams = [
  #   # Fix Wayland flickering & AMD-Vi IO_PAGE_FAULT errors with Nouveau
  #   # https://gitlab.freedesktop.org/drm/nouveau/-/issues/225
  #   "iommu=pt"
  # ];

  # TODO: verify if necessary
  boot.initrd.kernelModules = lib.mkBefore [
    "amdgpu"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = lib.mkBefore [ "nvidia" ];

  environment.systemPackages = [
    nvidia-offload
    pkgs.nvitop
  ];

  # FIX: external monitor no longer detected since dGPU is tied to the laptop dock
  # environment.variables = {
  #   # Use integrated GPU for gnome-shell
  #   # See https://gitlab.gnome.org/GNOME/mutter/-/issues/2969
  #   __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa.drivers.outPath}/share/glvnd/egl_vendor.d/50_mesa.json:${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
  #   __GLX_VENDOR_LIBRARY_NAME = "mesa";
  #   VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  #   DRI_PRIME = "pci-0000_06_00_0";
  # };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # powerManagement.finegrained = true;
    powerManagement.finegrained = false;

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
      # offload.enable = true;
      reverseSync.enable = true;
      # sync.enable = true;

      # Enable if using an external GPU
      allowExternalGpu = false;

      amdgpuBusId = "PCI:52:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # stable
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "560.35.03";
      sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
      sha256_aarch64 = "sha256-s8ZAVKvRNXpjxRYqM3E5oss5FdqW+tv1qQC2pDjfG+s=";
      openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
      settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
      persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";
    };
  };

}
