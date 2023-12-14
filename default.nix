sources
  @{ home-manager ? <home-manager>
   , nixos-hardware ? <nixos-hardware>
   , disko ? <disko>
   , impermanence ? <impermanence>
   , ...  
   }:
pkgsSelf: pkgsSuper:
let
  inherit ((import ./lib/overlay.nix pkgsSelf pkgsSuper).ek.lib.overlay)
    combine-many;
  
  inherit (pkgsSelf.ek.lib.modules)
    get-attrset;
  
  ek-extra = _: _:
    { ek.sources = sources;
      ek.Overlay = import ./. sources;
      ek.src = ./.;
      ek.modules = get-attrset ./modules;
    };
in
combine-many.recursive-this
  [ ek-extra
    (import ./lib)
    (import ./haskell)
    (import ./scripts)
  ]
