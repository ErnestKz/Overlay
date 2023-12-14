let
  pkgs = import ./nixpkgs.nix;
  
  imp = pkgs.ek.inputs.impermanence.outputs;

  # https://github.com/nix-community/disko/blob/master/lib/default.nix
  # https://github.com/nix-community/impermanence
  # https://nixos.wiki/wiki/Impermanence

  # https://github.com/nix-community/disko/blob/master/docs/quickstart.md
  # https://github.com/nix-community/disko/blob/master/docs/HowTo.md
  # https://github.com/nix-community/disko/tree/master
  
  disko-lib = pkgs.ek.inputs.disko.outputs.lib;
  disko = disko-lib.disko { lib = pkgs.lib; } ;
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
  
  disko-module-config =
    { disko.devices.disk.vbd = vbd;
      disko.devices.nodev."/tmp" = tmp;
    } ;

  disko-result = disko-lib.disko disko-module-config;
in
pkgs.writeScriptBin "disko-script" disko-result
# imp.nixosModules.impermanence {}
# imp.nixosModule {}

  
# disko.create
#   disko-module-config


# need to import disko as a module aswell?
# disko.config
#   disko-module-config
  
# pkgs.ek.inputs.disko.outputs.lib.disko
#   disko-module-config



  
# pkgs.ek.inputs.disko.outputs.packages.x86_64-linux.disko
# pkgs.ek.inputs.disko.outputs.packages.x86_64-linux.disko-doc
# https://github.com/nix-community/disko
# https://github.com/nix-community/impermanence  
