let
  redirect-overlay = import ./lib/redirect.nix;
  pkgs = import (import ./flake).sources.nixpkgs
    { overlays = [ redirect-overlay ]; };
  inherit (pkgs.ek.lib.redirect)
    redirect;
  originalOverlay = import ./flake;
in originalOverlay // { redirect = redirect "Overlay" originalOverlay; }
