pkgsSelf: pkgsSuper:
let
  ek-hextensions = pkgsSelf.ek.haskell.extensions;
  lib = pkgsSuper.lib;
in  
{
  ek.haskell.extensions.with-callCabal = hpkgsSelf: hpkgsSuper:
    { callCabal = packageName: packageDirectory: argumentSet:
        pkgsSelf.ek.haskell.lib.callCabalWith
          hpkgsSelf
          packageName
          packageDirectory
          argumentSet ;
    };
    
  ek.haskell.extensions.override-mkDerivation-fast = hpkgsSelf: hpkgsSuper:
    { mkDerivation = args: hpkgsSuper.mkDerivation (args // {
        doCheck = false;
        doHoogle = false;
        doHaddock = false;
        enableLibraryProfiling = false;
      }) ;
    };
    
  ek.haskell.extensions.package-set-for.ghc94 = hpkgsSelf: hpkgsSuper:
    { effectful-plugin = hpkgsSelf.callHackage "effectful-plugin" "1.1.0.1" {} ;
    };
  
  ek.haskell.extensions.package-set-for.ghc98 = hpkgsSelf: hpkgsSuper:
    { effectful-plugin = hpkgsSelf.callHackage "effectful-plugin" "1.1.0.1" {} ;
    };
  
  ek.haskell.extensions.package-set-for.ghc94-fast =
    lib.composeManyExtensions
      [ ek-hextensions.with-callCabal
        ek-hextensions.override-mkDerivation-fast
        ek-hextensions.package-set-for.ghc94
      ];

  ek.haskell.extensions.package-set-for.ghc98-fast =
    lib.composeManyExtensions
      [ ek-hextensions.with-callCabal
        ek-hextensions.override-mkDerivation-fast
        ek-hextensions.package-set-for.ghc98
      ];
}

