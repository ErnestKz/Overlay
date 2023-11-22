let
  nixpkgs = import ./nixpkgs.nix;
in
nixpkgs.ek.git.history ../.git
# nixpkgs.ek.git.read-rev-list ../.git
# [ (nixpkgs.ek.git.checkout "Overlay" ../.git "283c74e")
#   (nixpkgs.ek.git.rev-list "Overlay" ../.git )
# ]
