{
  lib,
  ...
}:
{
  # Additional boot menu selection for running the proprietary Nvidia drivers
  # NOTE: X11 feels smoother than Wayland, at least under Gnome
  specialisation = {
    nvidia-closed = {
      configuration = {
        system.nixos.tags = [ "nvidia-closed" ];
        environment.etc."specialisation".text = "nvidia-closed"; # hint for nh
        imports = [ ../hardware/nvidia.nix ];
      };
    };
  };
}
