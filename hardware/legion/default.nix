{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ../../modules/hardware/nvidia.nix # TODO:
    ./filesystems.nix
    ./virtual-camera.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    self.nixosModules.common-graphics
    self.nixosModules.common-hardware
    self.nixosModules.graphics-amd
  ];

  # Limit build resources
  nix.settings = {
    max-jobs = 4;
    cores = 12;
  };

  boot.kernelModules = [
    "kvm-amd"
    "legion-laptop"
  ];

  boot.initrd.availableKernelModules = [
    "legion-laptop"
    "nvme"
    "sd_mod"
    "thunderbolt"
    "usb_storage"
    "usbhid"
    "xhci_pci"
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ lenovo-legion-module ];
  environment.systemPackages = [ pkgs.lenovo-legion ];
}
