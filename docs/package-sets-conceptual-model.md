- a package set
  - a set of packages
    - the dependencies of a package need not be a part of the package set
- a package and its dependencies

in nix, can introduce the notion of different package sets of different types, e.g
- root package set, i.e the c dependencies/libraries
- haskell packaage set, with all the `hasellPackage` `mkDerivation` specific functionailities
- python package set, the same, with all the various nececities for python package ecossystem requirements
- notion of a package set on the `sources` level
  - thought the source "package" doesn't have any version
  
each package set corresponds with its own callPackage! callPackage is a package-set operation to instantiate
a package with its dependencies

each package in its attribute set sets its version

various statements which do the impure thing, useful for the sources level

can start with sources package set

```nix
ek.sources # is the package set corresponding to the sources
```

# so this is basically creating a `package-set`, that can be passed around and do `callPackage` with
pkgs-sources-picked = (pkgs-pinned
  .ek.sources.dev.Overlay.local ../Overlay)
  .ek.sources.dev.other-dep.c334273
  .ek.sources.dev.another-dep.latest
  .ek.sources.another-dep.latest


# types of package sets
- sources
- topelevel pkgs of nixpkgs
- haskellPackages
- pythonPackages


# how package repo is organised
- package.nix
  - a callPackage'able package
  
- default.nix
  - uses pins and does the callPackage on the package

perhaps theres multiple layers to a callPackage
- sources
- toplevel-pkgs
- haskellPackages/pythonPackages

# where will i use each packagae set

sources package set used for consolidating all the repositories into the Overlay


- overlay exposes a pinned version
  - can think of a package-set as a channel
    - can think of as the root package-set for source 
	
when importing ek, have access to the sources package set.
then have the utility of overriding them using that special syntax

suppose i have some personal haskell packages that i consolidate in ek
- first can access it on the level of source code and git revisions
- second is i can access it based on the cabal package version
  - get an attribute set of versions 
  
- perhaps have a derivation that contains indexed metadata of the source code
  - of each revision:
    - cabal version
	- compilation status
	- dependencies
- or rather an index of each release

for sources, simply can specify commit of the source, and get back a derivation which contains the sources
for packages, can either specify commit, or release version, and get the corresponding package

