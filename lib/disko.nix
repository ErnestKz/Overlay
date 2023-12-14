pkgsSelf: pkgsSuper:
let
  inherit (pkgsSuper) lib;
  inherit (pkgsSelf) ek;
  stateless-definition = import ek.modules.disko.stateless;
  disko = import ek.sources.disko {};
in  
{ ek.lib.disko.stateless.nixos-config = disko.config stateless-definition;
}
