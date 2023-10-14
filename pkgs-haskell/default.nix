_: pkgsSuper:
pkgsSuper.ek.lib.overlay.compose.recursive'
  [ (import ./haskellPackages94.nix)
    (import ./haskellPackages8107.nix)
    (import ./lib.nix)
  ]
