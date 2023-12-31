{ ek, ... }:
{ imports = [ (ek.sources.impermanence + "/nixos.nix") ];

  environment.persistence."/nix/persist" =
    { hideMounts = true;
      directories =
        [ "/var/log"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/etc/NetworkManager/system-connections"
          { directory = "/var/lib/colord";
            user = "colord";
            group = "colord";
            mode = "u=rwx,g=rx,o=";
          }
        ];
      
      files =
        [ "/etc/machine-id"
          { file = "/etc/nix/id_rsa";
            parentDirectory.mode = "u=rwx,g=,o=";
          }
        ];
      
      users.ek =
        { directories =
            [ "Downloads"
              "Music"
              "Pictures"
              "Documents"
              "Videos"
              { directory = ".gnupg";
                mode = "0700";
              }
              { directory = ".ssh";
                mode = "0700";
              }
              { directory = ".nixops";
                mode = "0700";
              }
              { directory = ".local/share/keyrings";
                mode = "0700";
              }
              ".local/share/direnv"
            ];
          files = [ ".screenrc" ];
        };
    };
}
