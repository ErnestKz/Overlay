pkgsSelf: pkgsSuper:
let
  composeOverlaysDeep =
    with pkgsSuper.lib;
    foldl
      (overlay: overlayAccum:
        pkgsSelf':
        pkgsSuper':
        recursiveUpdate
          (overlayAccum pkgsSelf' pkgsSuper')
          (overlay      pkgsSelf' pkgsSuper'))
      (_: _: {}) # Empty overlay
  ; 
in
composeOverlaysDeep [
  (_: _: {
    ek.lib.composeOverlaysDeep = composeOverlaysDeep;
  })
  (import ./lib/haskell)
  (import ./lib/hello.nix)
] pkgsSelf pkgsSuper
