let
  nixpkgs = import ./nixpkgs.nix;
in nixpkgs.ek.git.clone
