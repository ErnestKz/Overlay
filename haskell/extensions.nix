pkgsSelf: pkgsSuper:
let
  hext = pkgsSelf.ek.haskell.extensions;
  lib = pkgsSuper.lib;
  hlib = pkgsSuper.haskell.lib;
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

  # either overrideCabal or overrideAttrs
  ek.haskell.extensions.override-mkDerivation-passthru = hpkgsSelf: hpkgsSuper:
    { mkDerivation = args: (hpkgsSuper.mkDerivation args).overrideAttrs
      (oldAttrs: lib.recursiveUpdate oldAttrs
        (let library-deps = oldAttrs.passthru.getCabalDeps.libraryHaskellDepends;
             library-deps' = lib.filter (v: v != null) library-deps;
             library-deps-names =
               map
                 (p: { name = p.pname ;
                       version = p.version ;
                       deps = p.deps;
                     })
                 library-deps';
         in { passthru.deps = library-deps-names; })) ;
    };

   ek.haskell.extensions.override-mkDerivation-passthru-deps = hpkgsSelf: hpkgsSuper:
    { mkDerivation = args: (hpkgsSuper.mkDerivation args).overrideAttrs
      (oldAttrs: lib.recursiveUpdate oldAttrs
        (let library-deps = oldAttrs.passthru.getCabalDeps.libraryHaskellDepends;
             library-deps' = lib.filter (v: v != null) library-deps;
             library-deps-names =
               map
                 (p: if builtins.hasAttr "boot" p
                     then p.boot
                     else { name = p.pname ; version = p.version ; deps = p.deps; })
                 library-deps';
         in { passthru.deps = library-deps-names; })) ;
    };

  # ek.haskell.extensions.override-mkDerivation-passthru2 = hpkgsSelf: hpkgsSuper:
  #   { mkDerivation = args: hlib.overrideCabal (hpkgsSuper.mkDerivation args)
  #     (drv: { passthru.again = "hello 2 "; })
  #     ;
  #   };  
    
   ek.haskell.extensions.annotated-boot-libs = hpkgsSelf: hpkgsSuper:
     {
       # base = { boot = "base"; };
     };

   ek.haskell.extensions.package-set-for.ghc94 = hpkgsSelf: hpkgsSuper:
    { effectful-plugin = hpkgsSelf.callHackage "effectful-plugin" "1.1.0.1" {} ;
    };

  ek.haskell.extensions.package-set-for.ghc98 = hpkgsSelf: hpkgsSuper:
    { effectful-plugin = hpkgsSelf.callHackage "effectful-plugin" "1.1.0.1" {} ;
    };
  
  ek.haskell.extensions.package-set-for.ghc94-fast =
    lib.composeManyExtensions
      [ hext.with-callCabal
        hext.override-mkDerivation-fast
        hext.package-set-for.ghc94
      ];

  ek.haskell.extensions.package-set-for.ghc98-fast =
    lib.composeManyExtensions
      [ hext.with-callCabal
        hext.override-mkDerivation-fast
        hext.package-set-for.ghc98
      ];
}

