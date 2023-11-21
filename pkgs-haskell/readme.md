# Overriding Behaviour of how the `haskellPackage`s are Built

Can modify the `mkDerivation` that `haskellPackages` uses to build the packages for itself.

Can get arguments from
- https://github.com/NixOS/nixpkgs/blob/c51eaf4398a7c2f82d7d31d217191b06342571dc/pkgs/development/haskell-modules/generic-builder.nix#L12

# Extending Haskell Packages
To use `extensions` from `haskellPackages-extensions.nix`, do for example:
``` 
haskell.packages.ghc96.extend <overlay>

haskell.packages.ghc96.extend 
	(lib.composeExtensions <overlay1> <overlay2>)
	
haskell.packages.ghc96.extend 
	(lib.composeMany [ <overlay1> <overlay2> <overlay3>])
```

These `extensions` are basically overlays, local to `haskellPackages` of the `nixpkgs` infrastructure.


# GHC 
Would be nice to have a custom ghc builder interface via modules thats compatible with `nixpkgs`.
