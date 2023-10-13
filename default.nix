pkgsSelf: pkgsSuper:
let
  composeOverlays =
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
composeOverlays [
  (import ./lib/haskell)
  (import ./lib/hello.nix)
] pkgsSelf pkgsSuper
