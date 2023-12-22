let
  inherit (builtins)
    pathExists
    getEnv
    hasAttr
    trace
  ;
  
  config-path = (getEnv "HOME") + "/.sources.nix";
  config-exists = pathExists config-path;
  hasOverlay = hasAttr "Overlay" (import config-path);
  redirectedOverlay = (import config-path).Overlay;

  originalOverlay = import ./flake;
  finalOverlay =
    if config-exists && hasOverlay
    then trace "Redirect: Using Overlay defined in ${config-path}"
      redirectedOverlay
    else originalOverlay ;
in originalOverlay // { redirect = finalOverlay; }
