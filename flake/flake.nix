{
  description = "Pinned dependencies for Overlay.";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  
  outputs =
    { self
    , nixos-hardware
    , home-manager
    , flake-compat}: {
    lib.overlay = import ../.
      { inherit
        nixos-hardware
        home-manager ;
      };
  };
}
