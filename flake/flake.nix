{
  description = "Pinned dependencies for Overlay.";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.home-manager.url = "github:nix-community/home-manager";
  
  outputs =
    { self
    , nixos-hardware
    , home-manager }: {
    lib.overlay = import ../.
      { inherit
        nixos-hardware
        home-manager ;
      };
  };
}
