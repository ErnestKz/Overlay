{ pkgs, ek, ... }:
{
  system.autoUpgrade.enable = true;

  home-manager.extraSpecialArgs.ek = ek;
  home-manager.users.ek.imports = [ ek.modules.home-manager.shiva.root ];
  
  imports =
    [ (ek.sources.home-manager + "/nixos")
      (ek.sources.nixos-hardware + "/lenovo/thinkpad/x1/9th-gen")

      (ek.modules.nixos.shiva.boot)
      
      (ek.lib.disko.stateless.nixos-config)

      (ek.modules.nixos.shiva.nixpkgs)
      (ek.modules.nixos.shiva.system-nix)
      (ek.modules.nixos.shiva.users)
      
      (ek.modules.nixos.shiva.xserver.root)

      (ek.modules.nixos.shiva.network)
      (ek.modules.nixos.shiva.sound)
      (ek.modules.nixos.shiva.udev)
      (ek.modules.nixos.shiva.battery)
      (ek.modules.nixos.shiva.console)
      (ek.modules.nixos.shiva.locale)
      (ek.modules.nixos.shiva.virtualisation)

      # ./boot.nix
      # ./nixpkgs.nix
      # ./system-nix.nix
      # ./users.nix
      
      # ./network.nix
      # ./sound.nix
      # ./udev.nix
      # ./battery.nix
      # ./console.nix
      # ./locale.nix
      # ./virtualisation.nix
    ];
}
