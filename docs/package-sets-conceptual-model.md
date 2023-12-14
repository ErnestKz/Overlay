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
