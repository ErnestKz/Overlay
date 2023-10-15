{ pkgs, ... }:
{
  system.autoUpgrade.enable = true;
  home-manager.users.ek.imports =
    [ pkgs.ek.modules.home-manager.shiva ]; 
  imports =
    [ "${pkgs.ek.home-manager}/nixos"
      "${pkgs.ek.nixos-hardware}/lenovo/thinkpad/x1/9th-gen"
      ./boot.nix
      
      ./nixpkgs.nix
      ./nix.nix

      ./users.nix
      ./xserver

      ./network.nix
      ./sound.nix
      ./udev.nix
      ./battery.nix
      ./console.nix
      ./locale.nix

      ./virtualisation.nix
    ];
}
