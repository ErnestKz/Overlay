pkgsSelf: pkgsSuper:
let
  strings = pkgsSelf.lib.strings;
  lists = pkgsSelf.lib.lists;
  lib = pkgsSelf.lib;
  ek = pkgsSelf.ek;
in  
{
  ek.git.checkout = name: gitDir: commit:
    pkgsSelf.stdenv.mkDerivation {
      name = "${name}-${commit}-checkout";
      phases = [ "unpackPhase" "buildPhase" "cleanupPhase" "installPhase" ];
      unpackPhase = ''
        cp -r ${gitDir} ./.git
        chmod -R +rw ./.git
      '';
      buildPhase = "${pkgsSelf.git}/bin/git checkout ${commit}";
      cleanupPhase = "rm -rf ./.git";
      installPhase = "cp -r ./ $out/";
    };

  ek.git.rev-list = name: gitDir:
    pkgsSelf.stdenv.mkDerivation {
      name = "${name}-revisions";
      phases = [ "unpackPhase" "buildPhase" ];
      unpackPhase = ''
        cp -r ${gitDir} ./.git
        chmod -R +rw ./.git
      '';
      buildPhase = "${pkgsSelf.git}/bin/git rev-list --all > $out";
    };

  ek.git.read-rev-list = gitDir:
    let rev-list = strings.splitString "\n"
      (builtins.readFile (ek.git.rev-list "reading" gitDir));
    in
      # Remove last empty element due to trailing newline in rev-list.
      lists.sublist 0 ((lists.length rev-list) - 1) rev-list;

  ek.git.history = gitDir:
    lib.foldl
      (history_acc: revision:
        { "${revision}" = ek.git.checkout "creating-history" gitDir revision ; } // history_acc)
      {}
      (ek.git.read-rev-list gitDir) ;

  ek.git.clone = pkgsSelf.stdenv.mkDerivation {
    name = "clone";
    buildInputs = [ pkgsSelf.openssh ];
    phases = [ "buildPhase" "installPhase" ];
    buildPhase = ''
      ssh-keyscan -t rsa github.com >> ./known_hosts
      echo $key
      echo $key >> ssh -i /dev/stdin -o UserKnownHostsFile=./known_hosts -T git@github.com
      # ${pkgsSelf.git}/bin/git clone git@github.com:ErnestKz/Overlay.git
      
    '';
    installPhase = "cp -r ./Overlay $out/";
    impureEnvVars = [ "key" ];
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-Om4BcXK76QrExnKcDzw574l+h75C8yK/EbccpbcvLsQ=";
  };
}
