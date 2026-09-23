# Install with:
#   nix run nixpkgs#nixos-anywhere -- --flake .#<host> <name>@<ip> --vm-test

{
  inputs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "2G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # override existing partition

              # WARN:
              # Sub(sub)volumes must set a mountpoint in order to be mounted,
              # unless their parent is mounted. This said, disko will not
              # create `fileSystems` entry if the mountpoint is not specified [1^].
              #
              # [1^]: https://github.com/nix-community/disko/blob/725ea35e410ad83be4931d1bff7e090eacaf3563/lib/types/btrfs.nix#L256-L265
              subvolumes =
                let
                  defaultMountOptions = [
                    "compress-force=zstd:2"
                    "noatime"
                  ];
                in
                {
                  "@nixos" = {
                    mountpoint = "/";
                    mountOptions = defaultMountOptions;
                  };

                  "@nixos/nix" = {
                    mountpoint = "/nix";
                    mountOptions = defaultMountOptions;
                  };

                  "@nixos/home" = {
                    mountpoint = "/home";
                    mountOptions = defaultMountOptions;
                  };

                  "@nixos/var" = {
                    mountpoint = "/var";
                    mountOptions = defaultMountOptions;
                  };

                  "@nixos/snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = defaultMountOptions;
                  };

                  "@nixos/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "4G";
                  };
                };

              mountpoint = "/nixos-root";
            };
          };
        };
      };
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };
}
