let
  redirect-overlay = import ./lib/redirect.nix;
  pkgs = import (import ./flake).sources.nixpkgs
    { overlays = [ redirect-overlay ]; };
  inherit (pkgs.ek.lib.redirect)
    redirect
    redirect-with;
  originalOverlay = import ./flake;
in originalOverlay //
   { redirect = redirect "Overlay" originalOverlay;
     redirect-with = redirects: redirect-with
       redirects "Overlay" originalOverlay;
   }
