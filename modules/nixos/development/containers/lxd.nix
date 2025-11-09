{
  pkgs,
  username,
  ...
}:
{
  virtualisation.lxd.enable = true;
  virtualisation.lxd.recommendedSysctlSettings = true;

  users.users.${username}.extraGroups = [ "lxd" ];

  virtualisation.lxc = {
    enable = true;
    unprivilegedContainers = true;
    lxcfs.enable = true;
  };

  networking.firewall.trustedInterfaces = [ "lxdbr0" ];
}
