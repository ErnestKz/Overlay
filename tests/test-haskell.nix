let
  nixpkgs = import ./nixpkgs.nix;
  lib = nixpkgs.lib;
in
# lib.traceSeqN
  # 5
  # nixpkgs.ek.haskell.package-set.ghc98.aeson.passthru.getCabalDeps
  # nixpkgs.ek.haskell.package-set.ghc98.aeson.passthru
  # "hi"

  
nixpkgs.ek.haskell.package-set.ghc98.callCabal
  "haskell-test" ./haskell-test {}

