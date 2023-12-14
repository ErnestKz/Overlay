pkgsSelf: pkgsSuper:
let
  inherit (pkgsSuper) lib;
  inherit (lib) strings attrsets;
  inherit (pkgsSelf.ek.lib.modules) get-attrset;
  inherit (pkgsSelf.ek.sources) home-manager;
  evalHomeManager = import (home-manager + "/modules");
in  
{ ek.lib.modules.get-attrset = directory:
    lib.mapAttrs'
      (name: type:
        let path = directory + "/${name}"; in
        if
          type == "directory"
        then
          attrsets.nameValuePair
            name
            (get-attrset path)
        else
          attrsets.nameValuePair
            (strings.removeSuffix ".nix" name)
            path
      )
      (builtins.readDir directory);
  
  ek.lib.modules.eval-home-manager = modules:
    (evalHomeManager
      { configuration.imports = modules;
        extraSpecialArgs.ek = pkgsSelf.ek;
        pkgs = pkgsSuper;
        # check = false;
      }).config;
}
