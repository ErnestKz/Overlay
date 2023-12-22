let
  nixpkgs = import ../nixpkgs.nix;
  hpkgs = nixpkgs.ek.haskell.package-set.ghc94;
  haskell-test = hpkgs.callCabal
    "haskell-test" ./. {};
in
with nixpkgs;
mkShell {
  buildInputs =
    [ cabal-install
      haskell.packages.ghc94.haskell-language-server
    ];
  inputsFrom = [ haskell-test.env ];
}
