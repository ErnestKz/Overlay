{
  description = "Pinned dependencies for Overlay.";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.disko.url = "github:nix-community/disko";
  inputs.impermanence.url = "github:nix-community/impermanence";

  outputs =
    { self
    , nixpkgs-unstable
    , nixos-hardware
    , home-manager
    , disko
    , impermanence
    }:
    let
      inherit (nixpkgs-unstable) lib;
      inputs =
        { nixpkgs = nixpkgs-unstable ;
          inherit
            nixos-hardware
            home-manager
            disko
            impermanence ;
        };
      sources =
        (lib.mapAttrs
          (_: input: input.outPath)
          inputs) // { Overlay = ../.; };
    in 
      { Overlay' = import ../. sources;
        Overlay  = import ../.;
        inherit
          inputs
          sources
        ;
      };
}
