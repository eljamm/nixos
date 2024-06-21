{ config, ... }:
{
  imports = [
    ./filesystems.nix
    ./nvidia.nix
    ./virtual-camera.nix
    ./graphics.nix
  ];

  boot.kernelModules = [ "lenovo-legion-module" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ lenovo-legion-module ];
}
