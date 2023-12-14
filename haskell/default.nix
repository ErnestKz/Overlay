_: pkgsSuper:
pkgsSuper.ek.lib.overlay.combine-many.recursive-this
  [ (import ./extensions.nix)
    (import ./package-set.nix)
    (import ./lib.nix)
  ]
