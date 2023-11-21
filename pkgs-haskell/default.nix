_: pkgsSuper:
pkgsSuper.ek.lib.overlay.combine-many.recursive-this
  [ (import ./haskellPackages-extensions.nix)
    (import ./package-sets.nix)
    (import ./haskell-lib.nix)
  ]
