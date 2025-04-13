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
    ./filesystems.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    self.nixosModules.common-graphics
    self.nixosModules.common-hardware
    self.nixosModules.graphics-amd
    self.nixosModules.nvidia
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

  environment.systemPackages = [ pkgs.lenovo-legion ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    # for linux 6.13
    (lenovo-legion-module.overrideAttrs {
      pname = "lenovo-legion-module";
      version = "0.0.20-unstable-2025-04-01";

      src = pkgs.fetchFromGitHub {
        owner = "johnfanv2";
        repo = "LenovoLegionLinux";
        rev = "19fef88dbbb077d99052e06f3cd9a3675e7bf3aa";
        hash = "sha256-0lQ6LyfjZ1/dc6QjB4a1aBcfxY5lIJJEonwuy9a4V4I=";
      };
    })
  ];
}
