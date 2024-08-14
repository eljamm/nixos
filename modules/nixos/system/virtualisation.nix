{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  home-manager.users.kuroko = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };

  users.users.kuroko.extraGroups = [ "libvirtd" ];
  environment.systemPackages = [ pkgs.nixos-shell ];
}
