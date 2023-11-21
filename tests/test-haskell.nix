let
  nixpkgs = import ./nixpkgs.nix;
in
nixpkgs.ek.haskell.package-set.ghc98.callCabal
  "haskell-test" ./haskell-test {}
