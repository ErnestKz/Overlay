{ ek, ... }:
{
  nixpkgs.overlays = [ ];
  home.stateVersion = "23.05";
  imports = 
    [ (ek.modules.home-manager.common.packages)
      (ek.modules.home-manager.common.direnv)
      (ek.modules.home-manager.common.zsh)
      (ek.modules.home-manager.common.git)
      (ek.modules.home-manager.common.fonts)
      (ek.modules.home-manager.common.latex)
  ];
}
