let
  nvme =
    { type = "disk";
      device = "/dev/nvme0n1";
      content.type = "gpt";

      # /boot Partition
      content.partitions.boot =
        { size = "512M";
          type = "EF00";
          content.type = "filesystem";
          content.format = "vfat";
          content.mountpoint = "/boot";
        };

      # /nix partition, will also include /nix/persist
      content.partitions.nix =
        { size = "100%";
          content.type = "filesystem";
          content.format = "ext4";
          content.mountpoint = "/nix";
        };
    };

  # for '/'
  impersist =
    { fsType = "tmpfs";
      mountOptions =
        [ "size=3GB"
          "mode=755"            # Only root can write
        ];
    };

  # for '/tmp'
  tmp =
    { fsType = "tmpfs";
      mountOptions =
        [ "size=512M"
        ];
    };
  
in
{ disko.devices.disk.nvme = nvme;
  disko.devices.nodev."/" = impersist;
  disko.devices.nodev."/tmp" = tmp;
}
