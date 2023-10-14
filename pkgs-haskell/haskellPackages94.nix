pkgsSelf: pkgsSuper:
let
  hlib = pkgsSuper.haskell.lib;
  hpackages = pkgsSuper.haskell.packages;
in
{ ek.haskell.haskellPackages94 = hpackages.ghc94.override {
    overrides = (hPkgsSelf: hPkgsSuper: with hlib; {
      effectful-plugin = dontCheck (hPkgsSuper.callHackage "effectful-plugin" "1.1.0.1" {});
    });
  };
}
