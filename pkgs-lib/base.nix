pkgsSelf: pkgsSuper:
let
  lib = pkgsSuper.lib;
  overlay-combine-with = combine-function: m1: m2:
    self: super: combine-function (m1 self super) (m2 self super) ;
  
  overlay-combine-recursive = overlay-combine-with lib.recursiveUpdate;
  # is mostly comutative (looking through the perspective of attribute structure)
  # e.g
  #   lib.recursiveUpdate { hi.hi = 2; } { hi = 3; } => { hi = 3 }
  #   lib.recursiveUpdate { hi = 3; } { hi.hi = 2; } => { hi.hi = 2 }
  # truly commutative variant could be recursive update, but throwing an error
  # when something overrites a value with an attrset or an attrset with a value
  
  # this way will know when we are accidentally overriding already defined values.

  overlay-combine-overlap = overlay-combine-with (a: b: a // b);
  # is associative
  
  overlay-identity = _: _: {};
  
  overlay-combine-many-recursive =
    lib.foldl overlay-combine-recursive overlay-identity;
  overlay-combine-many-overlap =
    lib.foldl overlay-combine-overlap overlay-identity;
  
  overlay-combine-many-recursive-this =
    overlays:
    overlay-combine-many-recursive
      overlays
      pkgsSelf
      (pkgsSuper // export)
  ;

  export =
    { ek.lib.overlay =
        { overlay-combine-with = overlay-combine-with;
          identity = overlay-identity;
          combine =
            { recursive = overlay-combine-recursive;
              overlap = overlay-combine-overlap;
            };
          combine-many =
            { recursive = overlay-combine-many-recursive;
              recursive-this = overlay-combine-many-recursive-this;
              overlap = overlay-combine-many-overlap;
            };
        };
    };
  
in export
