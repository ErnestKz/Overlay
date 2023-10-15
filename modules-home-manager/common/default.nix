{ pkgs, ... }:
{
  nixpkgs.overlays = [ (import ../..) ];
  home.stateVersion = "23.05";
  imports = 
    [
      # pkgs.ek.home-manager
      ./packages.nix
      ./direnv.nix
      ./zsh.nix
      ./git.nix
      ./fonts.nix
      ./latex.nix
  ];
}
