_: {
  specialisation = {
    gnome = {
      inheritParentConfig = false;
      configuration = {
        system.nixos.tags = [ "Gnome" ];
        imports = [ ./default.nix ];
        desktops.gnome.enable = true;
      };
    };
    hyprland = {
      inheritParentConfig = false;
      configuration = {
        system.nixos.tags = [ "Hyprland" ];
        imports = [ ./default.nix ];
        desktops.hyprland.enable = true;
      };
    };
  };

}
