{ pkgs, specialArgs, ... }:
{
  imports =
    [ ../common
      ./home.nix
    ];
}
