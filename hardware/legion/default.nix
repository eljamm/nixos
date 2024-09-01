{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./filesystems.nix
    ./nvidia.nix
    ./virtual-camera.nix
    ./graphics.nix
  ];

  boot.kernelModules = [ "legion-laptop" ];
  boot.initrd.availableKernelModules = [ "legion-laptop" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ lenovo-legion-module ];
  environment.systemPackages = [ pkgs.lenovo-legion ];
}
