{ pkgs, ... }:
{
  nixpkgs.overlays = [
    # pkgs.hi
    # cannot access pkgs, it causes infinite recursion
    # because overlays must be causing a strict evaluation of some sort
  ];

  
  home.stateVersion = "23.05";
  imports = 
    [ ./packages.nix
      ./direnv.nix
      ./zsh.nix
      ./git.nix
      ./fonts.nix
      ./latex.nix
  ];
}
