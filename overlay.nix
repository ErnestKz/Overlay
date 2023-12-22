pkgsSelf: pkgsSuper:
let
  inherit ((import ./lib/overlay.nix pkgsSelf pkgsSuper).ek.lib.overlay)
    combine-many;
  inherit (pkgsSelf.ek.lib.modules)
    get-attrset;
  
  ek-pins = _: _: { ek = import ./flake; };
  ek-modules = _:_:
    { ek.modules = get-attrset ./modules; };
in
combine-many.recursive-this
  [ ek-pins
    ek-modules
    (import ./lib)
    (import ./haskell)
    (import ./scripts)
  ]
