_: pkgsSuper:
let
  inherit (pkgsSuper)
    lib
    newScope;

  inherit (lib.attrsets)
    attrByPath;

  inherit (builtins)
    pathExists
    getEnv
    trace;
in  
lib.makeScope newScope (self:
  let
    inherit (self.ek.lib.redirect) redirect-with ;
    default-redirect-path = (getEnv "HOME") + "/.redirect.nix";
  in
    { ek.lib.redirect.redirect = name: original:
        if pathExists default-redirect-path
        then trace "REDIRECT: ${name}"
          (redirect-with (import default-redirect-path) name original)
        else original ;
      ek.lib.redirect.redirect-with = redirects: name: original:
        attrByPath [ "redirect" name ] original redirects;
    })
