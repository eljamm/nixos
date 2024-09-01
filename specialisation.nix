{
  lib,
  ...
}:
{
  specialisation = {
    hyprland = {
      configuration = {
        system.nixos.tags = [ "Hyprland" ];
        desktops.gnome.enable = lib.mkForce false;
        desktops.hyprland.enable = true;
      };
    };
  };

}
