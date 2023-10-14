let
  nixpkgs-ek = import <nixpkgs>
    { overlays = [ (import ./default.nix) ]; };
in nixpkgs-ek.ek
