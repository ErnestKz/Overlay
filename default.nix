pkgsSelf: pkgsSuper:
let
  pkgsBase = import ./pkgs-lib/base.nix pkgsSelf pkgsSuper ;
in
pkgsBase.ek.lib.overlay.combine-many.recursive-this
  [ (import ./pkgs-lib)
    (import ./pkgs-haskell)
  ]
