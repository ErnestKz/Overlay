let
  outputs = import ../flake;
  nixpkgs = import outputs.deps.nixpkgs { overlays = [ outputs.overlay ]; };
in nixpkgs

