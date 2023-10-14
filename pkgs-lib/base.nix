pkgsSelf: pkgsSuper:
let
  lib = pkgsSuper.lib;
  overlay-mappend = f: m1: m2:
    self: super: f (m1 self super) (m2 self super) ;
  
  overlay-op-recursive = overlay-mappend lib.recursiveUpdate;
  # is comutative

  overlay-op-overlap = overlay-mappend (a: b: a // b);
  # is associative
  
  overlay-identity = (_: _: {});
  overlay-compose-recursive = lib.foldl overlay-op-recursive overlay-identity;
  overlay-compose-overlap = lib.foldl overlay-op-overlap overlay-identity;

  overlay-compose-recursive' =
    overlays:
    overlay-compose-recursive
      overlays
      pkgsSelf
      (pkgsSuper // export)
  ;

  export =
    { ek.lib.overlay =
        { mappend = overlay-mappend;
          identity =  _: _: {};
          op =
            { recursive = overlay-op-recursive;
              overlap = overlay-op-overlap;
            };
          compose =
            { recursive = overlay-compose-recursive;
              recursive' = overlay-compose-recursive';
              overlap = overlay-compose-overlap;
            };
        };
    };
  
in export
