{ home-manager ? <home-manager>
, nixos-hardware ? <nixos-hardware>
}:
pkgsSelf: pkgsSuper:
let
  pkgsOverlayLib = import ./pkgs-lib/overlay-merging.nix pkgsSelf pkgsSuper ;
  dependencies = _: _:
    { ek.deps.home-manager = home-manager ;
      ek.deps.nixos-hardware = nixos-hardware ;
      ek.deps.overlay = import ./. { inherit home-manager nixos-hardware ; };
      ek.deps.src = ./.;
    };
in
pkgsOverlayLib.ek.lib.overlay.combine-many.recursive-this
  [ dependencies
    (import ./pkgs-lib)
    (import ./pkgs-haskell)
    (import ./modules-home-manager)
    (import ./modules-nixos)
  ]
