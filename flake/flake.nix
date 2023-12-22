{
  description                 = "Pinned dependencies for Overlay.";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
  inputs.nixos-hardware.url   = "github:NixOS/nixos-hardware";
  inputs.home-manager.url     = "github:nix-community/home-manager";
  inputs.disko.url            = "github:nix-community/disko";
  inputs.impermanence.url     = "github:nix-community/impermanence";

  outputs =
    { self
    , nixpkgs-unstable
    , nixos-hardware
    , home-manager
    , disko
    , impermanence
    }:    
    let
      inherit (nixpkgs-unstable) lib newScope;
      pinned-sources = lib.mapAttrs
        (_: input: input.outPath)
        { nixpkgs = nixpkgs-unstable ;
          inherit
            nixos-hardware
            home-manager
            disko
            impermanence ;
        };
    in lib.makeScope newScope (self:
      { sources = pinned-sources // { overlay = ../overlay.nix; };
        overlay = import self.sources.overlay;
        nixpkgs-with-overlay = import self.sources.nixpkgs
          { overlays = [ self.overlay ]; };
      });
}
