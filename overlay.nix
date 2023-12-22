pkgsSelf: pkgsSuper:
let
  inherit ((import ./lib/overlay.nix pkgsSelf pkgsSuper).ek.lib.overlay)
    combine-many;
  inherit ((import ./lib/redirect.nix pkgsSelf pkgsSuper).ek.lib.redirect)
    redirect;
  inherit (pkgsSelf.ek.lib.modules)
    get-attrset;
  inherit (pkgsSelf.lib)
    mapAttrs;
  
  redirected-sources = mapAttrs
    (name: value: redirect name value)
    (import ./flake).sources;
  
  ek-pins = _: _:
    { ek = import ./flake; } //
    { ek.sources = redirected-sources; };
  ek-modules = _:_:
    { ek.modules = get-attrset ./modules; };
  
  ek-packages = _:_:
    { ek.ek-xmonad = import redirected-sources.ek-xmonad ;
    };
in
combine-many.recursive-this
  [ ek-packages
    ek-pins
    ek-modules
    (import ./lib)
    (import ./haskell)
    (import ./scripts)
  ]
