{ ... }:
{
  nix.settings = {
    experimental-features =
      [ "nix-command"
        "flakes"
      ];

    nix-path =
      [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
        "nixos-config=/etc/nixos/configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    
    extra-substituters = [ ];
    extra-trusted-public-keys = [ ];
    extra-trusted-users = [ "ek" ];

    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html
    extra-system-features = [];
    pre-build-hook = [];
    post-build-hook = [];
    extra-plugin-files = [];
  };
}
