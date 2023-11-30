inputs
  @{ home-manager ? <home-manager>
   , nixos-hardware ? <nixos-hardware>
   , disko ? <disko>
   , impermanence ? <impermanence>
   , ...  
   }:
pkgsSelf: pkgsSuper:
let
  pkgs-with-merging-lib =
    import ./pkgs-lib/overlay-merging.nix pkgsSelf pkgsSuper ;
  ek-sources = _: _:
    { ek.inputs = inputs;
      ek.Overlay = import ./. inputs;
      ek.src = ./.;
    };
in
pkgs-with-merging-lib.ek.lib
  .overlay
  .combine-many
  .recursive-this
  [ ek-sources
    (import ./pkgs-lib)
    (import ./pkgs-haskell)
    (import ./modules-home-manager)
    (import ./modules-nixos)
  ]
