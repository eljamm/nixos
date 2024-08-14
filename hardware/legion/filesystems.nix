{ lib, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/35a6b011-b49c-41e6-9742-f389377bb609";
      fsType = "btrfs";
      options = [
        "subvol=@nixos/root"
        "compress-force=zstd:2"
        "noatime"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/35a6b011-b49c-41e6-9742-f389377bb609";
      fsType = "btrfs";
      options = [
        "subvol=@nixos/nix"
        "compress-force=zstd:2"
        "noatime"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/35a6b011-b49c-41e6-9742-f389377bb609";
      fsType = "btrfs";
      options = [
        "subvol=@nixos/home"
        "compress-force=zstd:2"
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/0429-2254";
      fsType = "vfat";
    };

    "/var" = {
      device = "/dev/disk/by-uuid/35a6b011-b49c-41e6-9742-f389377bb609";
      fsType = "btrfs";
      options = [
        "subvol=@nixos/var"
        "compress-force=zstd:2"
        "noatime"
      ];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/35a6b011-b49c-41e6-9742-f389377bb609";
      fsType = "btrfs";
      options = [
        "subvol=@nixos/snapshots"
        "compress-force=zstd:2"
        "noatime"
      ];
    };

    "/home/kuroko/Storage" = {
      device = "/dev/disk/by-uuid/35a6b011-b49c-41e6-9742-f389377bb609";
      fsType = "btrfs";
      options = [
        "subvol=@storage"
        "compress-force=zstd:2"
        "noatime"
      ];
    };

    "/run/media/kuroko/ExternalHDD" = {
      device = "/dev/disk/by-uuid/a1131a59-5e59-4845-bb9c-e0588a3b266e";
      fsType = "btrfs";
      options = [
        "compress-force=zstd:2"
        "noatime"
        "nofail"
        "x-systemd.device-timeout=5"
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
