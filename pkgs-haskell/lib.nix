pkgsSelf: pkgsSuper:
let
  hlib = pkgsSuper.haskell.lib;
in  
{
  ek.haskell.useCabal =
    newCabal:
    originalDerivation:
    hlib.overrideCabal
      originalDerivation
      (previousOverrides: {
        setupHaskellDepends = (
          if previousOverrides ? setupHaskellDepends
          then previousOverrides.setupHaskellDepends
          else []) ++ [ newCabal ];
      })
  ;

  ek.haskell.callCabal2nix =
    packageName:
    packageDirectory:
    argumentSet:
    haskellPackages:
    let
      callCabal2NixWithHaskellPackages = haskellPackagesOther:
        let
          haskellPackage =
            haskellPackagesOther.callCabal2nix
              packageName
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
              })
              argumentSet
          ;
          
        in haskellPackage
      ;
      
      haskellPackage = callCabal2NixWithHaskellPackages haskellPackages
      ;

    in haskellPackage // {
      withOtherHaskellPackages = callCabal2NixWithHaskellPackages ;
    }
  ;
}
