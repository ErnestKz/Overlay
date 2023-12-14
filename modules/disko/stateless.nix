let
  vbd =
    { device = "/dev/vbd";
      type = "disk";
      content.type = "gpt";
      content.partitions.ESP =
        { size = "500M";
          type = "EF00";
          content.type = "filesystem";
          content.format = "vfat";
          content.mountpoint = "/boot";
        };
      content.partitions.root =
        { size = "100%";
          content.type = "filesystem";
          content.format = "ext4";
          content.mountpoint = "/";
        };
    };

  tmp =
    { fsType = "tmpfs";
      mountOptions = [ "size=200M" ];
    };
in
{ disko.devices.disk.vbd = vbd;
  disko.devices.nodev."/tmp" = tmp;
}
