let
  outputs = import ../flake;
  nixpkgs = import outputs.inputs.nixpkgs-flake
    { overlays = [ outputs.Overlay ]; };
in nixpkgs

