{ inputs, self, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    self.nixosModules.common-graphics
    self.nixosModules.common-hardware
    #../../modules/hardware/nvidia.nix # transcoding
    ./filesystems.nix
  ];

  boot.kernelModules = [ "kvm-intel" ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "rtsx_usb_sdmmc"
    "sd_mod"
    "sr_mod"
    "uas"
    "usb_storage"
    "usbhid"
    "xhci_pci"
  ];

  # Blacklist nouveau
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';
}
