{ pkgs, ... }:
{
  nixpkgs.overlays = [ ];
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
