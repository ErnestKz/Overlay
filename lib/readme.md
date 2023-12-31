## `git.nix`

We want to have the history of a package available through its nix expression.

## `overlay-merging.nix` 
Buildings blocks of this Overlay repo. Logic for combining overlays.

It's made available as part of pkgsSuper in order to avoid infinite recursion!

### Creating Namespaces
We can emulate namespaces via attribute sets e.g:
```nix
pkgsSelf: pkgsSuper: 
{
  ek.haskell.extensions.with-callCabal = ...
  ek.haskell.extensions.override-mkDerivation-fast = ...
}
```
In order to have this behaviour across multiple overlays, the resulting attribute sets need to be combined with `lib.recursiveUpdate`, rather than the standard way through `lib.composeExtensions`, which does the (`//`) operator shallow merge.


### Indepndent Modules
To be able to declare overlays in a more independent way, best that the overlay or "module" merging behaviour is commutative.

`lib.recursiveUpdate` has 2 cases where it is not commutative:
```
lib.recursiveUpdate { hi.hi = 2; } { hi = 3; } => { hi = 3 }
lib.recursiveUpdate { hi = 3; } { hi.hi = 2; } => { hi.hi = 2 }
```
Truly commutative variant could be a recursive update, but throwing an error when something overrites a value with an attrset or an attrset with a value.

This way will know when we are accidentally overriding already defined values, creating a more decoupled experience.

## Techniques to Explore

- Fixed Output Derivations:
  - impureEnvVars
    - https://nixos.org/manual/nix/stable/language/advanced-attributes.html?highlight=outputHash#advanced-attributes
	- https://nixos.org/manual/nix/stable/contributing/experimental-features#xp-feature-configurable-impure-env
	- for the ssh key
  - outputHash
    - https://bmcgee.ie/posts/2023/02/nix-what-are-fixed-output-derivations-and-why-use-them/
	- for cloning repo
