let
  nixpkgs-ek = import <nixpkgs>
    { overlays = [ (import ./default.nix {}) ]; };
  
  evald = nixpkgs-ek.lib.evalModules
    { modules = [ nixpkgs-ek.ek.modules.nixos.shiva ]; };
in evald
