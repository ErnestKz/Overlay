let
  nixpkgs = import ./nixpkgs.nix;
  evaluated-modules = nixpkgs.lib.evalModules
    { modules = [ nixpkgs.ek.modules.nixos.shiva ];
      specialArgs = { ek = nixpkgs.ek; };
    };
in
{ modules = evaluated-modules;
  pkgs = nixpkgs;
}


