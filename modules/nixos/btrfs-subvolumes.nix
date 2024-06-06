{
  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "2048M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "/@nixos/root" = {
                    mountOptions = [
                      "defaults"
                      "compress=zstd:2"
                      "noatime"
                    ];
                    mountpoint = "/";
                  };
                  "/@nixos/home" = {
                    mountOptions = [
                      "defaults"
                      "compress=zstd:2"
                      "noatime"
                    ];
                    mountpoint = "/home";
                  };
                  "/@nixos/home/kuroko" = { };
                  "/@nixos/nix" = {
                    mountOptions = [
                      "defaults"
                      "compress=zstd:2"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                  "/@nixos/var" = {
                    mountOptions = [
                      "defaults"
                      "compress=zstd:2"
                      "noatime"
                    ];
                    mountpoint = "/var";
                  };
                  "/@nixos/var/cache" = { };
                  "/@nixos/var/lib" = { };
                  "/@nixos/var/log" = { };
                  "/@nixos/snapshots" = {
                    mountOptions = [
                      "defaults"
                      "compress=zstd:2"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                };

                mountpoint = "/partition-root";
              };
            };
          };
        };
      };
    };
  };
}
