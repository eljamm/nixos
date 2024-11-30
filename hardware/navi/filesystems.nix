{ config, ... }:
{
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/1E27-BBE2";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-uuid/e0fc1633-1185-4386-a07a-52ade66f63e1";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress-force=zstd:2"
        "noatime"
      ];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/e0fc1633-1185-4386-a07a-52ade66f63e1";
      fsType = "btrfs";
      options = [
        "subvol=@snapshots"
        "compress-force=zstd:2"
        "noatime"
      ];
    };

    "/media" = {
      device = "/dev/disk/by-uuid/e0fc1633-1185-4386-a07a-52ade66f63e1";
      fsType = "btrfs";
      options = [
        "subvol=@media"
        "compress-force=zstd:2"
        "noatime"
        "users"
      ];
    };
  };

  zramSwap = {
    enable = true;
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };
}
