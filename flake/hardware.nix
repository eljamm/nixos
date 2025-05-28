{ inputs, ... }:
{
  flake.nixosModules.common-hardware =
    { pkgs, lib, ... }:
    let
      linux_xanmod_custom = pkgs.linuxPackagesFor (
        pkgs.linux_xanmod.override {
          argsOverride = rec {
            version = "6.14.8";
            modDirVersion = "${version}-xanmod1";

            src = pkgs.fetchFromGitLab {
              owner = "xanmod";
              repo = "linux";
              rev = modDirVersion;
              hash = "sha256-ap3NaM/pk+TWg3RBRxFJPwnfv2n042r47bo66jhj3ck=";
            };
          };
        }
      );
    in
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Kernel
      boot.kernelPackages = linux_xanmod_custom;
      # boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;

      # Userspace schedulers (default scx_rustland)
      # https://github.com/sched-ext/scx/blob/main/scheds/rust/README.md
      services.scx.enable = lib.mkDefault true;
      # Prioritize interactivity and responsiveness under CPU-intensive loads
      services.scx.scheduler = lib.mkDefault "scx_bpfland";

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
