{
  self,
  inputs,
  system,
  devLib,
  pkgsCustom,
  pkgsUnstable,
  ...
}:
let
  devArgs = {
    inherit
      self
      inputs
      system
      pkgsCustom
      pkgsUnstable
      devLib
      ;
  };
in
{
  joker = devLib.nixosSystem {
    username = "kuroko";
    modules = [
      inputs.agenix.nixosModules.default
      inputs.catppuccin.nixosModules.catppuccin
      inputs.chaotic.nixosModules.default
      self.nixosModules.default
      self.nixosModules.apps.gaming.default
      self.nixosModules.apps.obs
      self.nixosModules.apps.spicetify
      self.nixosModules.audio.musnix
      self.nixosModules.desktops.gnome.default
      self.nixosModules.desktops.hyprland.default
      self.nixosModules.development.rust
      self.nixosModules.development.containers.podman
      self.nixosModules.services.anki
      self.nixosModules.services.blocky
      self.nixosModules.services.keyd
      self.nixosModules.services.misc
      self.nixosModules.services.mumble
      self.nixosModules.services.printing
      self.nixosModules.system.virtualisation
      self.homeModules.users.kuroko
      ./nixos
    ];
    specialArgs = devArgs;
  };

  navi = devLib.nixosSystem {
    username = "navi";
    modules = [
      inputs.agenix.nixosModules.default
      inputs.catppuccin.nixosModules.catppuccin
      self.nixosModules.default
      self.nixosModules.development.containers.podman
      self.nixosModules.services.anki
      self.nixosModules.services.media
      self.homeModules.users.navi
      ./navi
    ];
    specialArgs = devArgs;
  };

  mona = null;
}
