pkgsSelf: pkgsSuper:
let lib = pkgsSuper.lib;
in lib.makeScope pkgsSuper.newScope (self:
  let
    inherit (self.ek.lib.overlay)
      combine-with
      combine
      combine-many
      identity
    ;
  in
    { ek.lib.overlay.identity = _: _: {} ;
      ek.lib.overlay.combine-with = combine-function: m1: m2:
        self: super: combine-function (m1 self super) (m2 self super) ;
      
      ek.lib.overlay.combine.recursive = combine-with lib.recursiveUpdate ;
      ek.lib.overlay.combine.overlap = combine-with (a: b: a // b) ;

      ek.lib.overlay.combine-many.recursive = lib.foldl combine.recursive identity ;
      ek.lib.overlay.combine-many.overlap = lib.foldl combine.overlap identity ;

      # like combine many recursive, but does 2 additional things:
      # - implicitly provides the overlay the pkgSelf, and pkgsSuper to the resulting overlay.
      # - adds boot libraries to pkgsSuper.
      ek.lib.overlay.combine-many.recursive-this = overlays:
        combine-many.recursive overlays pkgsSelf (pkgsSuper // { ek = self.ek ; }) ;
    })
