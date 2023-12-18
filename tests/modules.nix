{
  system ? builtins.currentSystem,
  sources ? import ./sources.nix,
}:
let
	pkgs = import sources.nixpkgs { 
		config = { };
		overlays = [ (import sources.Overlay sources) ];
		inherit system;
	};
	inherit (pkgs) lib;
in
lib.makeScope pkgs.newScope (self: {
	shell = pkgs.mkShell { packages = [ ]; };

  moduleEval = lib.evalModules { modules = [ ]; };
  
	nixosSystem =
    import (sources.nixpkgs + "/nixos")
      { configuration = pkgs.ek.modules.nixos.shiva.root;
	    };
	
  # nixosSystemSpecial.config.system.build.toplevel
  nixosSystemSpecial =
    import (sources.nixpkgs + "/nixos/lib/eval-config.nix")
      { inherit system;
	      modules = [
          pkgs.ek.modules.nixos.shiva.root
          # ../modules-nixos/shiva/root.nix
        ];
	      specialArgs.ek = pkgs.ek;
      };
  
  nixosSystemSpecial' =
    self.nixosSystemSpecial
      .config
      .system
      .build
      .toplevel;

  nixosSystemSpecial'' =
    self.nixosSystemSpecial
      .config
      .system
      .build
      .vm;
})
