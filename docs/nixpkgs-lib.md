# Utlities from `nixpkgs`
`nixpkgs` contains a lot interesting functions for:
- filesystems
- source cleaning
- regex stuff

- [`lib`](https://github.com/NixOS/nixpkgs/tree/35a3cb94c6ef119a7049d8c742b07ecb23ad76a0/lib)

- [tweag lib docs](https://tweag.github.io/nixpkgs/file-sets/manual.html#sec-functions-library-fileset)

- [`lib.debug`](https://github.com/NixOS/nixpkgs/blob/dfea4e4951a3cee4d1807d8d4590189cf16f366b/lib/debug.nix)

- [`lib.sources`](https://github.com/NixOS/nixpkgs/blob/35a3cb94c6ef119a7049d8c742b07ecb23ad76a0/lib/sources.nix)
  
#### `fileset`
A new, and conceptuallly clean set of utilities to work with files. 

Though there's a lot of existing older utilites that are very useful, so don't necessarily want to go all in on this.

```
fileset.union a b
fileset.unions [ ... ]

fileset.intersect a b
fileset.intersects [ ... ]

fileset.difference a b

fileset.fileFilter predicate a

fileset.toSource { root = ./.; fileset = my-fs; }
# only local files at eval time supported 
```
