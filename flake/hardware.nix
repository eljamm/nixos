{ inputs, ... }:
{
  flake.nixosModules.common-hardware =
    { pkgs, lib, ... }:
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Kernel
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;

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

  imports = [
    ../modules/hardware/chaotic.nix
    ../modules/hardware/graphics.nix
    # TODO:
    ../modules/home-manager
    ../modules/nixos/desktops
    ../modules/nixos/desktops/cosmic
    ../modules/nixos/desktops/gnome
    ../modules/nixos/desktops/hyprland
  ];
}
