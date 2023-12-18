let
  nixpkgs = import ../nixpkgs.nix;
  haskell-test = nixpkgs.ek.haskell.package-set.ghc94.callCabal
    "haskell-test" ./. {};
in
with nixpkgs;
mkShell {
  buildInputs = [ nixpkgs.cabal-install ];
  inputsFrom = [ haskell-test.env ];
}
