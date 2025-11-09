{ inputs, self, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    self.hardwareModules.default
    self.hardwareModules.graphics.default
    self.hardwareModules.graphics.nvidia
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

  # Fair scheduler with consistent performance
  # https://github.com/sched-ext/scx/blob/main/scheds/rust/scx_flash/README.md
  services.scx.scheduler = "scx_flash";
}
