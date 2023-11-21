pkgsSelf: pkgsSuper:
let
  hlib = pkgsSuper.haskell.lib;
  ek-hlib = pkgsSelf.ek.haskell.lib;
in  
{
  ek.haskell.lib.cleanSources =
    packageName: packageDirectory:
      (builtins.path {
        name = packageName;
        path = packageDirectory;
        filter = path: type: 
          path != ".envrc"
          && (builtins.baseNameOf path != "dist-newstyle")
          && (builtins.baseNameOf path != "dist")
          && (builtins.baseNameOf path != ".direnv")
          && (builtins.baseNameOf path != "result")
        ;
      });

  ek.haskell.lib.callCabal2nixWith =
    hPkgs: hPkgs.callCabal2nix ;  
  
  ek.haskell.lib.callCabalWith =
    hPkgs:
    packageName:
    packageDirectory:
    argumentSet:
    let
      haskellSources = ek-hlib.cleanSources packageName packageDirectory;
      haskellPackage =
        ek-hlib.callCabal2nixWith
          hPkgs
          packageName
          haskellSources
          argumentSet ;
    in haskellPackage ;

  ek.haskell.lib.useCabal =
    newCabal:
    originalDerivation:
    hlib.overrideCabal
      originalDerivation
      (previousOverrides: {
        setupHaskellDepends = (
          if previousOverrides ? setupHaskellDepends
          then previousOverrides.setupHaskellDepends
          else []) ++ [ newCabal ];
      }) ;
}
