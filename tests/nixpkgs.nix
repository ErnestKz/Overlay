let
  sources = (import ../flake).sources;
  Overlay = import sources.Overlay sources;
  nixpkgs = import sources.nixpkgs { overlays = [ Overlay ]; };
in nixpkgs

