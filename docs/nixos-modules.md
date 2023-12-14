## Writing NixOS Modules

- https://www.youtube.com/watch?v=N7hFP_40DJo

- Boiler-plate for evaluating modules.
- Different arguments to a module.
  - pkgs
    - the nixpkgs package set.
  - lib
    - lib of nixpkgs, includes functions to use on modules.
  - config
    - access to the final config.
  - Adding more arguments.
  
- `environment.systemPackages = lib.mkIf config.appstream.enable [ pkgs.git ]`
- Different things that can go into import.
  - {}
  - {}:{}
  - a file
  
- Inspecting the evaluated config.
  - load the boiler plate file, and can explore the config.
  - can use lib functions to do filters and inspect further.

- Another type of module:
  - options/config

```nix
options.mine.desktop.enable = lib.mkEnableOption "desktop settings";
```
- When we introduce a top-level `options` or `config` attribute, the other options that usually be available, cease to be available.
  - Have to move the option usages that don't declare new ones into `config`. (except for `import`, it can stay at the top-level)



- There is also `disabledModules`
  - can reference internal modules by providing a string, under 
    - nixpkgs/nixos/modules, module-list.nix
	- "config/appstream.nix"
  - also works the same as `imports` for toplevel option thing
  
- "declaring" options is the options section
- "definiting" options is the config section

- `submodule` type is like a struct.

```nix
{ lib, ... }: {
	imports = [ { mine.foo.y = 20 } ];
	options.mine.foo = lib.mkOption {
	  type = lib.types.attrsOf lib.types.int;
	};
  config.mine.foo.x = 10;
}
```

```nix
{ lib, ... }: {
	imports = [ { mine.foo.y.number = 20 } ];
	options.mine.foo = lib.mkOption {
	  type = lib.types.attrsOf (lib.types.submodule {
        options.number = lib.mkOption { type = lib.types.int; };
	  });
	};
  config.mine.foo.x.number = 10;
}
```

- option declerations themselves have merging capabilites, just like config definitions


Creates infinite recursion:
```nix
{ myModules, ... }: {
  imports = [
    (myModules + "/foo")
  ];
  _module.args.myModules = ./modules
}
```
Have to do it via specialArgs at the evalModules/eval...


variations of boiler plate module code:
- 48
- 56:00

```nix
{
  system ? builtins.currentSystem,
  sources ? import ./npins,
}:
let
	pkgs = import sources.nixpkgs { 
		config = {};
		overlays = [];
		inherit system;
	};
	inherit (pkgs) lib;
in
lib.makeScope pkgs.newScope (self: {
	shell = pkgs.mkShell [
	  packages = [ pkgs.npins self.myPackage ];
    ];
	
	nixosSystem = import (sources.nixpkgs + "/nixos") {
      configuration = ./configuration.nix;
	};
	
	moduleEval = lib.evalModules {
		modules = [
         # ...
		];
	};
	
   nixosSystem2 = import (sources.nixpkgs + "/nixos/lib/eval-config.nix") {
	inherit system;
	modules = [ ./configuration.nix ];
	specialArgs.myModules = ./modules;
   };
})
```

```
nix-instantiate -A nixosSystem.system
```
