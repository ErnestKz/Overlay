with import <nixpkgs> {};
mkShell {
  packages = [ pkgs.npins ];
}
