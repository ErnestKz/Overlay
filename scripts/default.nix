pkgsSelf: pkgsSuper:
let
  inherit (pkgsSelf.ek.lib.modules)
    get-attrset;
in  
{ ek.scripts = get-attrset ./.;
}
