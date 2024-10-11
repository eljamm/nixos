{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./filesystems.nix
    ./graphics.nix
    ./nvidia.nix
    ./virtual-camera.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  powerManagement.cpuFreqGovernor = "performance";
}
