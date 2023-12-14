let
  nixpkgs = import ./nixpkgs.nix;
  disko = import nixpkgs.ek.sources.disko {};
in
disko

