pkgsSelf: pkgsSuper:
let
  hext = pkgsSelf.ek.haskell.extensions;
  lib = pkgsSuper.lib;
in
{
  ek.haskell.package-set.ghc92 =
    pkgsSelf.haskell.packages.ghc92.extend
      (lib.composeManyExtensions
        [ hext.base
          hext.package-set-for.ghc92
        ]);

  ek.haskell.package-set.ghc94 =
    pkgsSelf.haskell.packages.ghc94.extend
      (lib.composeManyExtensions
        [ hext.base
          hext.package-set-for.ghc94
        ]);

  ek.haskell.package-set.ghc96 =
    pkgsSelf.haskell.packages.ghc96.extend
      (lib.composeManyExtensions
        [ hext.base
          hext.package-set-for.ghc96
        ]);

  ek.haskell.package-set.ghc98 =
    pkgsSelf.haskell.packages.ghc98.extend
      (lib.composeManyExtensions
        [ hext.base
          hext.package-set-for.ghc98
        ]);
}
