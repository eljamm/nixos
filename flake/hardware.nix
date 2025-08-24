{ self, ... }:
{
  flake.nixosModules.common-hardware =
    {
      pkgs,
      lib,
      system,
      config,
      ...
    }:
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Kernel
      boot.kernelPackages = pkgs.linuxPackagesFor self.packages.${system}.linux_xanmod_custom;
      # boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;

      boot.kernelPatches = [
        # Potential fix for flip_done timed out issue (at least for VRR)
        # https://gitlab.freedesktop.org/drm/amd/-/issues/2950
        { patch = ../hosts/nixos/overlays/patches/xanmod_fix_flip_done.patch; }
      ];

      # Userspace schedulers (default scx_rustland)
      # https://github.com/sched-ext/scx/blob/main/scheds/rust/README.md
      services.scx.enable = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.12") true;
      # Prioritize interactivity and responsiveness under CPU-intensive loads
      services.scx.scheduler = lib.mkDefault "scx_bpfland";

      systemd.services.scx =
        let
          cfg = config.services.scx;
        in
        {
          serviceConfig.ExecStart = lib.mkForce ''
            ${pkgs.runtimeShell} -c 'exec ${cfg.package}/bin/''${SCX_SCHEDULER_OVERRIDE:-$SCX_SCHEDULER} ''${SCX_FLAGS_OVERRIDE:-$SCX_FLAGS}'
          '';
          environment = {
            SCX_SCHEDULER = cfg.scheduler;
            SCX_FLAGS = lib.escapeShellArgs cfg.extraArgs;
          };
        };

      # https://wiki.archlinux.org/title/CPU_frequency_scaling#Scaling_governors
      powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

      # Enable non-free firmware
      hardware.enableRedistributableFirmware = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
