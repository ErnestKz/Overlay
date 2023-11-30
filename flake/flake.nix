{
  description = "Pinned dependencies for Overlay.";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.disko.url = "github:nix-community/disko";
  inputs.impermanence.url = "github:nix-community/impermanence";

  # Maybe instead of flake, just a source pin?
  
  outputs =
    { self
    , nixpkgs-unstable
    , nixos-hardware
    , home-manager
    , disko
    , impermanence
    }:
    let
      inputs =
        { nixpkgs-flake = nixpkgs-unstable ;
          inherit
            nixos-hardware
            home-manager
            disko
            impermanence ;
        };
    in 
      { Overlay    = import ../. inputs;
        Overlay-fn = import ../.;
        inputs     = inputs;
      };
}
