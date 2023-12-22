pkgsSelf: pkgsSuper:
let
  hext = pkgsSelf.ek.haskell.extensions;
  hlib = pkgsSuper.haskell.lib;
  lib = pkgsSuper.lib;
in  
{
  ek.haskell.extensions.with-callCabal =
    hpkgsSelf: hpkgsSuper:
    { callCabal = packageName: packageDirectory: argumentSet:
        pkgsSelf.ek.haskell.lib.callCabalWith
          hpkgsSelf
          packageName
          packageDirectory
          argumentSet ;
    };
    
  ek.haskell.extensions.override-mkDerivation-fast =
    hpkgsSelf: hpkgsSuper:
    { mkDerivation = args: hpkgsSuper.mkDerivation (args // {
        doCheck = false;
        doHoogle = false;
        doHaddock = false;
        enableLibraryProfiling = false;
      }) ;
    };

  # either overrideCabal or overrideAttrs
  ek.haskell.extensions.override-mkDerivation-passthru =
    hpkgsSelf: hpkgsSuper:
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

  ek.haskell.extensions.override-mkDerivation-passthru-deps =
    hpkgsSelf: hpkgsSuper:
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
    
   ek.haskell.extensions.annotated-boot-libs =
     hpkgsSelf: hpkgsSuper:
     {
       # base = { boot = "base"; };
     };


   ek.haskell.extensions.base-package-set =
     hpkgsSelf: hpkgsSuper:
     { effectful-plugin = hpkgsSelf.callHackage "effectful-plugin" "1.1.0.2" {} ;
       effectful-th = hlib.doJailbreak hpkgsSuper.effectful-th;
       th-abstraction = hpkgsSelf.callHackage "th-abstraction" "0.6.0.0" {} ;
       bifunctors = hpkgsSelf.callHackage "bifunctors" "5.6.1" {} ;
       free = hpkgsSelf.callHackage "free" "5.2" {} ;

       aeson = hpkgsSelf.callHackage "aeson" "2.2.1.0" {} ;

       glib = hpkgsSelf.callHackage "glib" "0.13.10.0" { glib = pkgsSuper.glib; } ;
       cairo = hpkgsSelf.callHackage "cairo" "0.13.10.0" { cairo = pkgsSuper.cairo; } ;
       pango = hpkgsSelf.callHackage "pango" "0.13.10.0" { pango = pkgsSuper.pango; } ;
       http-conduit = hpkgsSelf.callHackage "http-conduit" "2.3.8.3" { } ;
       attoparsec-aeson = hpkgsSelf.callHackage "attoparsec-aeson" "2.2.0.1" { } ;
       
       tagged = hpkgsSelf.callHackage "tagged" "0.8.8" {} ;
       tasty = hpkgsSelf.callHackage "tasty" "1.5" {} ;
       
       cleff = hlib.markUnbroken hpkgsSuper.cleff;
       xmonad-contrib = hpkgsSelf.callHackage "xmonad-contrib" "0.17.1" {} ;
       xmonad = hpkgsSelf.callHackage "xmonad" "0.17.2" {} ;
       xmobar = hpkgsSelf.callHackage "xmobar" "0.47.2" {} ;
     };

   ek.haskell.extensions.package-set-for.ghc92 =
     hpkgsSelf: hpkgsSuper:
     {
     };
     
   ek.haskell.extensions.package-set-for.ghc94 =
     hpkgsSelf: hpkgsSuper:
     {
     };

   ek.haskell.extensions.package-set-for.ghc96 = 
     hpkgsSelf: hpkgsSuper:
     {
     };
   
   ek.haskell.extensions.package-set-for.ghc98 =
     hpkgsSelf: hpkgsSuper:
     {
     };

  ek.haskell.extensions.base =
    lib.composeManyExtensions
      [ hext.with-callCabal
        hext.override-mkDerivation-fast
        hext.base-package-set
      ];
}

