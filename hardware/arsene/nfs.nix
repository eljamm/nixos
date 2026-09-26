#
# https://wiki.nixos.org/wiki/NFS
#
{
  fileSystems."/export/storage" = {
    device = "/run/media/storage";
    fsType = "none";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export 192.168.1.0/24(insecure,rw,sync,no_subtree_check,crossmnt,fsid=0)
      /export/storage 192.168.1.0/24(insecure,rw,sync,no_subtree_check)
    '';
  };

  # NOTE: Some clients may only support NFSv3, in which case more ports need to
  # be enabled [^1]. I haven't encountered any yet, so I'll be using NFSv4.
  #
  # [^1]: https://wiki.nixos.org/wiki/NFS#Firewall
  networking.firewall.allowedTCPPorts = [
    2049
  ];
}
