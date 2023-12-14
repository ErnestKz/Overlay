_: pkgsSuper:
pkgsSuper.ek.lib.overlay.combine-many.recursive-this
  [ (import ./overlay.nix)
    (import ./git.nix)
    (import ./disko.nix)
    (import ./modules.nix)
  ]
