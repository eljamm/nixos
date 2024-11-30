{ ... }:
{
  flake.nixosModules = {
    virtualisation =
      { pkgs, username, ... }:
      {
        virtualisation.libvirtd.enable = true;
        programs.virt-manager.enable = true;

        home-manager.users.${username} = {
          dconf.settings = {
            "org/virt-manager/virt-manager/connections" = {
              autoconnect = [ "qemu:///system" ];
              uris = [ "qemu:///system" ];
            };
          };
        };

        users.users.${username}.extraGroups = [ "libvirtd" ];
        environment.systemPackages = [ pkgs.nixos-shell ];

        # TODO: remove this?
        # services.spice-vdagentd.enable = true;
        services.qemuGuest.enable = true;
      };
  };
}
