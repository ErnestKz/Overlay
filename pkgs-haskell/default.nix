_: pkgsSuper:
pkgsSuper.ek.lib.overlay.combine-many.recursive-this
  [ (import ./haskellPackages94.nix)
    (import ./haskellPackages8107.nix)
    (import ./lib.nix)
  ]
