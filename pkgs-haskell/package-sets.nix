pkgsSelf: pkgsSuper:
let
  hext = pkgsSelf.ek.haskell.extensions;
in    
{
  ek.haskell.package-set.ghc94 =
    pkgsSelf.haskell.packages.ghc94.extend
      hext.package-set-for.ghc94-fast ;
  
  ek.haskell.package-set.ghc98 =
    pkgsSelf.haskell.packages.ghc98.extend
      hext.package-set-for.ghc98-fast ;
}
