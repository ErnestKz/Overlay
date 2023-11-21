{
  description = "Pinned dependencies for Overlay.";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.home-manager.url = "github:nix-community/home-manager";
  
  outputs =
    { self
    , nixpkgs-unstable
    , nixos-hardware
    , home-manager }:
    {
      overlay = import ../. { inherit home-manager nixos-hardware ; };
      deps = {
        inherit
          nixos-hardware
          home-manager ;
        nixpkgs = nixpkgs-unstable ;
      };
  };
}
