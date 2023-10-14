pkgsSelf: pkgsSuper:
let
  hlib = pkgsSuper.haskell.lib;
  hpackages = pkgsSuper.haskell.packages;
in
{ ek.haskell.haskellPackages8107 = hpackages.ghc8107.override {
    overrides = hPkgsSelf: hPkgsSuper: with hlib; { };
  };
}
