{ home-manager ? <home-manager>
, nixos-hardware ? <nixos-hardware>
}:
pkgsSelf: pkgsSuper:
let
  pkgsBase = import ./pkgs-lib/base.nix pkgsSelf pkgsSuper ;
  externalDeps = (_:_:
    { ek = { home-manager = home-manager ;
             nixos-hardware = nixos-hardware ;
             # overlay = import ./. { inherit home-manager nixos-hardware ; };
           };
    });
in
pkgsBase.ek.lib.overlay.combine-many.recursive-this
  [ externalDeps
    (import ./pkgs-lib)
    (import ./pkgs-haskell)
    (import ./modules-home-manager)
    (import ./modules-nixos)
  ]
