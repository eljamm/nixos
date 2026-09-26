{
  username,
  config,
  ...
}:
{
  imports = [
    ./nfs.nix
  ];

  boot.supportedFilesystems = [
    "ntfs"
  ];

  fileSystems = {
    "/run/media/storage" = {
      device = "/dev/disk/by-uuid/14A0B7FD40F81F25";
      fsType = "ntfs3";
      options = [
        "rw"
        "uid=${toString config.users.users.${username}.uid}"
      ];
    };
  };

  zramSwap = {
    enable = true;
  };
}
