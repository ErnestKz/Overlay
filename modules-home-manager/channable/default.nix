{ pkgs, ... }:
{
  imports =
    [
      ../common
      # pkgs.ek.modules.home-manager.common
      # this also causes infiite recursion
      ./home.nix
    ];
}
