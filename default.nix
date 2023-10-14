pkgsSelf: pkgsSuper:
let
  pkgsBase = import ./pkgs-lib/base.nix pkgsSelf pkgsSuper ;
in
pkgsBase.ek.lib.overlay.compose.recursive'
  [ (import ./pkgs-lib)
    (import ./pkgs-haskell)
  ]
