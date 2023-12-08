# shell.nix
with import <nixpkgs> {};
let hpkgs = haskellPackages.extend (hpkgsSelf: hpkgsSuper:
    { effectful-plugin = hpkgsSelf.callHackage "effectful-plugin" "1.1.0.1" {} ;
     #...
    });
   mypkg = hpkgs.callCabal2nix "haskell-test" ./. {};
in 
mkShell {
  buildInputs = [
    cabal-install
    # haskell.packages.ghc96.haskell-language-server
  ];
  packages = [];
  inputsFrom = [ mypkg.env ];
}
